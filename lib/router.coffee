if Meteor.isClient
  BlazeLayout.setRoot('body')

checkLoggedIn = () ->
  unless Meteor.loggingIn() or Meteor.userId()
    console.log "not logged"
    FlowRouter.go '/login'
    # redirect('/login')

alreadyLoggedIn = () ->
  if Meteor.userId()
    console.log "alredy logged"
    FlowRouter.go '/'
    # redirect('/login')

FlowRouter.route '/',
  name: 'home'
  triggersEnter: [checkLoggedIn],
  action: (params) ->
    console.log "at base route"
    BlazeLayout.render 'layout',
      dashboard: 'flirt'

FlowRouter.route '/flirt',
  name: 'flirt'
  triggersEnter: [checkLoggedIn],
  action: (params) ->
    BlazeLayout.render 'layout',
      dashboard: 'flirt'

FlowRouter.route '/birt',
  name: 'birt'
  triggersEnter: [checkLoggedIn],
  action: (params) ->
    BlazeLayout.render 'layout',
      dashboard: 'birt'

FlowRouter.route '/login',
  name: 'login'
  triggersEnter: [alreadyLoggedIn],
  action: (params) ->
    BlazeLayout.render 'layout',
      dashboard: 'login'

FlowRouter.route '/logoutuser',
  # name: 'logoutUser'
  action: (params) ->
    console.log "start logout", Meteor.userId()
    # Meteor.logout()
    # console.log "after logout", Meteor.userId()
    # FlowRouter.go '/login'
    Meteor.logout()
    console.log "after logout", Meteor.userId()
    FlowRouter.go '/login'
    # Meteor.logout (err) ->
    #   console.log err if err
    #   console.log "after logout", Meteor.userId()
    #   # Session.set 'ses', false
    #   # window.location = "/login"
    #   FlowRouter.go '/login'

FlowRouter.route '/register',
  name: 'register'
  action: (params) ->
    BlazeLayout.render 'layout',
    dashboard: 'register'

if Meteor.isClient
  Meteor.autorun () ->
    console.log "change", Meteor.userId()

