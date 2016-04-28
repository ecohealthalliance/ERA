Template.register.events
  'submit #register' : (event, instance) ->
    event.preventDefault()
    email = instance.$('#email').val()
    password  = instance.$('#password').val()
    Meteor.call 'registerNewUser', email, password, (err, result) ->
      console.log 'ERROR: ', err if err
      toastr.success("Your account has been created!")
      FlowRouter.go('/login')
