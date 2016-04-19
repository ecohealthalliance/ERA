if Meteor.isClient
  BlazeLayout.setRoot('body')

checkLoggedIn = () ->
  unless Meteor.loggingIn() or Meteor.userId()
    console.log "not logged"
    FlowRouter.go 'login'
    # redirect('/login')

alreadyLoggedIn = () ->
  if Meteor.userId() or Meteor.loggingIn()
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

FlowRouter.route '/logoutUser',
  # name: 'logoutUser'
  action: (params) ->
    console.log "start logout"
    Meteor.logout()
    FlowRouter.go '/login'
    # Meteor.logout (err) ->
    #   console.log err if err
    #   console.log "after logout"
    #   # Session.set 'ses', false
    #   FlowRouter.go 'login'
    console.log "after after"

FlowRouter.route '/register',
  name: 'register'
  action: (params) ->
    BlazeLayout.render 'layout',
    dashboard: 'register'

if Meteor.isClient
  Meteor.autorun () ->
    console.log "change", Meteor.userId()

