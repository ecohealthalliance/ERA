if Meteor.isClient

  BlazeLayout.setRoot('body')

  FlowRouter.route '/',
    action: (params) ->
      Meteor.autorun ->
        if Meteor.loggingIn() or Meteor.user()
          FlowRouter.redirect '/flirt'
        else
          BlazeLayout.render 'login'

  loggedIn = FlowRouter.group
    triggersEnter: [ ->
      unless Meteor.loggingIn() or Meteor.userId()
        route = FlowRouter.current()
        FlowRouter.redirect '/'
    ]

  loggedIn.route '/register',
    action: (params) ->
      BlazeLayout.render 'register',
        dashboard: 'register'

  loggedIn.route '/flirt',
    action: (params) ->
      BlazeLayout.render 'layout',
        dashboard: 'flirt'

  loggedIn.route '/birt',
    action: (params) ->
      BlazeLayout.render 'layout',
        dashboard: 'birt'

  loggedIn.route '/logout',
    action: (params) ->
      Meteor.logout ->
        FlowRouter.redirect '/'
