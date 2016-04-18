if Meteor.isClient
  BlazeLayout.setRoot('body')

checkLoggedIn = () ->
  if !Meteor.userId()
    console.log Meteor.userId()
    console.log "User not logged in - redirecting..."
    FlowRouter.go 'login'
    # redirect('/login')

FlowRouter.route '/',
  name: 'home'
  triggersEnter: [checkLoggedIn],
  action: (params) ->
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
  action: (params) ->
    BlazeLayout.render 'layout',
    dashboard: 'login'

FlowRouter.route '/register',
  name: 'register'
  action: (params) ->
    BlazeLayout.render 'layout',
    dashboard: 'register'

