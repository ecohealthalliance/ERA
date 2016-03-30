if Meteor.isClient
  BlazeLayout.setRoot('body')

FlowRouter.route '/',
  name: 'home'
  action: (params) ->
    BlazeLayout.render 'layout',
      dashboard: 'flirt'

FlowRouter.route '/flirt',
  name: 'flirt'
  action: (params) ->
    BlazeLayout.render 'layout',
      dashboard: 'flirt'

FlowRouter.route '/birt',
  name: 'birt'
  action: (params) ->
    BlazeLayout.render 'layout',
      dashboard: 'birt'
