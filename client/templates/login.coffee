Template.login.events
  'submit #login' : (event, instance) ->
    event.preventDefault()
    email = $('#email').val()
    password  = $('#password').val()
    Meteor.call 'loginUser', email, password, (err, result) ->
      console.log 'ERROR: ', err if err
      console.log "login result", result
      if result
        console.log 'logged in'
        Meteor.loginWithToken(result);
        toastr.success("You have logged in!")
        FlowRouter.go('/')
