Meteor.startup () ->
  @Future = Npm.require('fibers/future');

initiateAdminAuthentication = (callback) ->
  initiateAuthentication "amAdmin", "zBLPuWe+ylyqt0", (result) ->
    callback(result)

initiateAuthentication = (email, password, callback) ->
  #in order to start making requests to the OpenAM API we first need to get a base request framework and token
  Meteor.http.call  "POST",
    "http://openam.eha.io:8080/openam/json/authenticate?Content-Type=application/json",
    (err, result) ->
      #using the returned framework as a base - set the username/password of the user we want to login as
      result.data.callbacks[0].input[0].value = email
      result.data.callbacks[1].input[0].value = password
      callback(result.data)

authenticate = (data, callback) ->
  authData = {}
  authData.data = data
  Meteor.http.call  "POST",
    "http://openam.eha.io:8080/openam/json/authenticate?Content-Type=application/json"
    authData,
    (err, result) ->
      requestBody = {}
      headers = {}
      headers["Content-Type"] = "application/json"
      headers["iplanetDirectoryPro"] = result.data.tokenId
      console.log err if err
      # console.log result
      requestBody.headers = headers
      callback(requestBody)
      # console.log requestBody

createUser = (userCreateData, callback) ->
  #create the user in OpenAM
  Meteor.http.call "POST",
    "http://openam.eha.io:8080/openam/json/users/?_action=create",
    # headers,
    userCreateData,
    (err, result) ->
      console.log "ERROR: ", err if err
      throw err if err
      #add the user in the local meteor database
      Accounts.createUser
        email: userCreateData.data.mail,
        password: userCreateData.data.userpassword
      callback(result)
      # console.log result



Meteor.methods
  getAnalyticsData: () =>
    future = new Future()
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
              callback(err, {sources: sources, monthlyTotals: response.totalsForAllResults } )
          )
        ],
        (err, results) ->
          future["return"]({
            today: results[0],
            ThirtyDays: results[1]
          })
    return future.wait()

  registerNewUser: (email, password) =>
    initiateAdminAuthentication (authData) ->
      authenticate authData, (userData) ->
        userData.data = {
            "username": email,
            "userpassword": password,
            "mail":email
        }
        createUser userData, (result) ->
          console.log result

  loginUser: (email, password) =>
    future = new Future()
    initiateAuthentication email, password, (authData) ->
      authenticate authData, (userData) ->
        # # even though actual authentication takes place on the OpenAM server, we
        # # will also log the user in locally to setup the base session.  That is
        # # why it is important to store the current password in the local db as well.
        # Meteor.loginWithPassword(email, password)
        tokenObject =
          token: userData.headers.iplanetDirectoryPro
          when: new Date
        user = Accounts.findUserByEmail(email)
        Accounts._insertLoginToken(user._id, tokenObject)
        # Meteor.loginWithToken(tokenObject);
        # console.log "userData:",tokenObject
        # console.log "user: ", user
        future["return"](tokenObject.token)
    future.wait()

  changeUserPassword: (currentPassword, newPassword) =>
    # make sure that we change the password in both OpenAM and in the Meteor db (even thought we don't use the local password for anything...)
    console.log "implement this"

  logoutUser: () =>
    Accounts.logout()
    #logout of openAM also
