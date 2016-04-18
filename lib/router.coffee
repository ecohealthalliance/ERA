if Meteor.isClient
  BlazeLayout.setRoot('body')

checkLoggedIn = () ->
  if !Meteor.userId()
    FlowRouter.go 'login'
    # redirect('/login')

alreadyLoggedIn = () ->
    FlowRouter.go '/'
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
  triggersEnter: [alreadyLoggedIn],
  action: (params) ->
    BlazeLayout.render 'layout',
    dashboard: 'login'

# FlowRouter.route '/logout',
#   name: 'logout'
#   action: (params) ->
#     console.log "start with logout"
#     Meteor.logout ->
#       console.log "done with logout"
#       Session.set 'ses', false
#       FlowRouter.go 'login'

FlowRouter.route '/register',
  name: 'register'
  action: (params) ->
    BlazeLayout.render 'layout',
    dashboard: 'register'

