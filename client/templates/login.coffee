Template.login.events
  'click #login' : (evt, instance) ->
    email = $("#email").val()
    password  = $("#password").val()
    Meteor.call 'loginUser', email, password, (err, result) ->
      console.log "ERROR: ", err if err
      # console.log "login result", result
      Meteor.loginWithToken(result);
      redirect("/")
