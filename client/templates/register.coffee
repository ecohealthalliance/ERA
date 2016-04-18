Template.register.events
  'click #register' : (evt, instance) ->
    email = $("#email").val()
    password  = $("#password").val()
    Meteor.call 'registerNewUser', email, password, (err, result) ->
      console.log "ERROR: ", err if err
