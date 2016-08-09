Meteor.startup =>
  @Future = Npm.require('fibers/future')
  @GoogleApis = Npm.require('googleapis')


Meteor.methods
  getFlightCounts: =>
    @FlightTotals.find().count()

  getLegCounts: =>
    @LegTotals.find().count()

  getAnalyticsData: ->
    # # url = "https://analyticsreporting.googleapis.com/v4/reports:batchGet"
    # # params =
    # #     data:
    # #         'viewId': 'ga:114507084'
    # #         'dateRanges': [{'startDate': 'today', 'endDate': 'today'}]
    # #         'metrics': [{'expression': 'ga:users'}]
    # # Meteor.call("POST", url)
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
