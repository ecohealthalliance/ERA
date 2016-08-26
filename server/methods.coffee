Meteor.startup =>
  @Future = Npm.require('fibers/future')
  @GoogleApis = Npm.require('googleapis')

Meteor.methods
  getFlightCounts: =>
    @FlightTotals.find().count()

  getLegCounts: =>
    @LegTotals.find().count()

  getArticleCounts: =>
    @ArticleCounts.find().count()

  getDiseaseInfoByMonth: _.memoize((disease) =>
    diseaseInfo = @ArticleCounts.aggregate([
        {$match: {"subject.diseaseLabels": disease}},
        {$group   : { 
            _id: {
              year: {$year: "$promedDate"}
              month: {$month: "$promedDate"}
            },
            number : { $sum : 1 }
          }
        },
        {$sort    : { _id : 1 } }
    ])
    # fill in missing dates with 0 counts
    newDates = []
    years = _.uniq(
          _.map diseaseInfo, (item) -> 
            item._id.year
        )
    newDates = []
    for year in years
      for i in [1...12]
        entry = _.find(diseaseInfo, (disease) -> disease._id.year == year && disease._id.month == i)
        d = moment().date(1).month(i-1).year(year)
        if entry
          entry._id = d.format('YYYY-MM-DD')
          newDates.push(entry)
        else
          newDates.push {_id: d.format('YYYY-MM-DD'), number: 0}
    newDates
  )

  getDiseaseInfoByWeek: _.memoize((disease) =>
    diseaseInfo = @ArticleCounts.aggregate([
        {$match: {"subject.diseaseLabels": disease}},
        {$group   : { 
            _id: {
              year: {$year: "$promedDate"}
              week: {$week: "$promedDate"}
            },
            number : { $sum : 1 }
          }
        },
        {$sort    : { _id : 1 } }
    ])
    # fill in missing dates with 0 counts
    years = _.uniq(
              _.map diseaseInfo, (item) -> 
                item._id.year
            )
    newDates = []
    for year in years
      for i in [0...53]
        entry = _.find(diseaseInfo, (disease) -> disease._id.year == year && disease._id.week == i)
        d = moment().day("Sunday").week(i).year(year)
        if entry
          entry._id = d.format('YYYY-MM-DD')
          newDates.push(entry)
        else
          newDates.push {_id: d.format('YYYY-MM-DD'), number: 0}
    newDates
  )

  getDiseaseInfoByDay: _.memoize((disease) =>
    diseaseInfo = @ArticleCounts.aggregate([
        {$match: {"subject.diseaseLabels": disease}},
        {$project : { day : {$substr: ["$promedDate", 0, 10] }}},
        {$group   : { _id : "$day",  number : { $sum : 1 }}},
        {$sort    : { _id : 1 } }
    ])
    # fill in missing dates with 0 counts
    minDate = new Date(diseaseInfo[0]._id).getTime()
    maxDate = new Date(diseaseInfo[diseaseInfo.length - 1]._id).getTime()
    currentDate = minDate
    newDates = []
    while currentDate <= maxDate
      d = moment(currentDate).format('YYYY-MM-DD')
      entry = _.find(diseaseInfo, (disease) -> disease._id == d)
      if entry
        newDates.push entry
      else
        newDates.push {_id: d, number: 0}
      currentDate += (24 * 60 * 60 * 1000);
    newDates
  )

  getDiseaseNames: _.memoize( () =>
    diseases = @ArticleCounts.find({},
                  fields: 'subject.diseaseLabels': true
                ).fetch().map((x) ->
                  x.subject.diseaseLabels
                )
    _.uniq(_.flatten(diseases)).sort()
  )


  #throttlling to only hit Analytics api once per hour
  getAnalyticsData: _.throttle( () ->
    future = new Future()
    jwtClient = new GoogleApis.auth.JWT(
      Meteor.settings.private.ga_private_key.client_email,
      null,
      Meteor.settings.private.ga_private_key.private_key,
      ['https://www.googleapis.com/auth/analytics.readonly'],
      null
    )
    jwtClient.authorize (err, tokens) ->
      if err
        console.log "Error authorizing"
        console.log err
        return

      analytics = GoogleApis.analytics('v3')
      async.parallel [
        (callback) ->
          analytics.data.ga.get(
            {
              'ids': 'ga:114507084',
              'metrics':'ga:sessions',
              'start-date': 'today',
              'end-date': 'today',
              'auth': jwtClient
            }
            (err, response) ->
              if err
                console.log "Error in getting GA Metrics"
                console.log err, response
              callback(err, response.totalsForAllResults)
          )
        ,
        (callback) ->
          analytics.data.ga.get(
            {
              'ids': 'ga:114507084',
              'metrics':'ga:sessions',
              'dimensions': 'ga:source,ga:keyword',
              'start-date': '30daysAgo',
              'end-date': 'today',
              'auth': jwtClient
            }
            (err, response) ->
              if err
                console.log "Error in getting GA Metrics"
                console.log err, response
              sources = _.map response.rows, (row) ->
                  source: row[0]
                  count: row[2]
              callback err,
                sources: sources
                monthlyTotals: response.totalsForAllResults
          )
        ],
        (err, results) ->
          console.log results
          future["return"]({
            today: results[0],
            ThirtyDays: results[1]
          })
    return future.wait()
  , 3600000)
