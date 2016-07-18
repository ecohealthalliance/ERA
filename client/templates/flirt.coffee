FlightCounts = ()->
  @FlightCounts
Template.flirt.helpers
  flightCounts: ->
    "123,673"
  flightCountInfo: ->
    "Total flights: " + Template.instance().flightCounts.get()
  legCountInfo: ->
    "Total legs: " + Template.instance().legCounts.get()
  flirtActiveUsers: =>
    Template.instance().userData.get().today?["ga:sessions"]
  flirtUsers30: =>
    Template.instance().userData.get().ThirtyDays?.monthlyTotals?["ga:sessions"]
  flirtSources: =>
    Template.instance().userData.get().ThirtyDays?.sources
  flirtDowntime: ->
    "2 horus 17 minutes"
  flirtDowntime: ->
    "2h 17m downtime"
  flirtDowntimeInfo: ->
    "since 2/15/2016"
  paneState: ->
    Template.instance().paneState
  paneVisible: (paneName)->
    if paneName == Template.instance().paneState.get()
      'visible'

Template.flirt.onCreated ->
  @userData = new ReactiveVar {}
  @flightCounts = new ReactiveVar {}
  @legCounts = new ReactiveVar {}
  @paneState = new ReactiveVar 'flight-chart'
  Meteor.autorun () =>
    Meteor.call 'getAnalyticsData', (err, result) =>
      @userData.set result
    Meteor.call 'getFlightCounts', (err, result) =>
      @flightCounts.set result
    Meteor.call 'getLegCounts', (err, result) =>
      @legCounts.set result

