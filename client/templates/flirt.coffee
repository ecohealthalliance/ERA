FlightCounts = ()->
  @FlightCounts
Template.flirt.helpers
  flightCounts: ->
    "123,673"
  flightCountInfo: ->
    "flights added since 3/3/2016"
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
  @paneState = new ReactiveVar 'flight-chart'
  @subscribe 'flightCounts'
  instance = @
  Meteor.defer () =>
    Meteor.autorun () =>
      Meteor.call 'getAnalyticsData',
        (err, result) ->
          instance.userData.set(result)
      counts = FlightCounts().find().fetch()
      cleanDates = _.map counts, (item) ->
        return {date: item.date.toLocaleDateString(), count: item.count}
      Highcharts.chart 'flight-chart',
          chart:
              type: 'line',
              zoomType: 'x'
          ,
          title:
              text: 'Flights per day'
          ,
          xAxis:
              name: 'Date',
              categories: _.pluck(cleanDates,'date')
          ,
          yAxis:
              title:
                  text: 'Number of Flights'
          ,
          series: [
              name: 'Flights per day',
              data: _.pluck(cleanDates,'count')
          ]
