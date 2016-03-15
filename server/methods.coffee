Meteor.methods
  getAnalyticsData: () =>
    # console.log "calling getAnalyticsData"
    jwtClient = new GoogleApis.auth.JWT(
      Meteor.settings.client_email, 
      null, 
      Meteor.settings.private_key, 
      ['https://www.googleapis.com/auth/analytics.readonly'], 
      null
    )

    jwtClient.authorize (err, tokens)=>
      if err
        console.log "Error authorizing"
        console.log err
        return

      analytics = GoogleApis.analytics('v3');
      async.parallel [
        (callback) ->
          analytics.data.ga.get(
            { 
              'ids': 'ga:114507084', 
              'metrics':'ga:sessions', 
              # 'dimensions': 'ga:source,ga:keyword',
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
              callback(err, {rows: response.rows, totalsForAllResults: response.totalsForAllResults } )
          )
        ],
        (err, results) ->
          console.log "results", results
          return {
            today: results[0],
            ThirtyDays: results[1]
          }



