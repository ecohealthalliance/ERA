FlightCounts = ()->
  @FlightCounts
Template.flirt.helpers
  flightCounts: ->
    "123,673"
  flightCountInfo: ->
    "flights added since 3/3/2016"
  flirtActiveUsers: =>
    # Template.instance().userData.get().today?["ga:sessions"]
  flirtUsers30: =>
    # Template.instance().userData.get().ThirtyDays?.monthlyTotals?["ga:sessions"]
  flirtSources: =>
    # Template.instance().userData.get().ThirtyDays?.sources
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
  @paneState = new ReactiveVar 'flight-chart'
