Template.nav.events
  'click #logout' : (evt, instance) =>
    console.log "start logout"
    Meteor.logout()
    console.log "done"
    # Meteor.logout (err) ->
    #   console.log err if err
    #   console.log "after logout"
    #   # Session.set 'ses', false
    #   FlowRouter.go 'login'