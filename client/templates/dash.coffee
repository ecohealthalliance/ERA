Template.dash.helpers
  flightCounts: ->
    "123,673"
  flightCountInfo: ->
    "flights added since 3/3/2016"
  flirtActiveUsers: ->
    "32"
  flirtDowntime: ->
    "2 horus 17 minutes"
  flirtActiveUsers: ->
    "32"
  flirtDowntime: ->
    "2h 17m downtime"
  flirtDowntimeInfo: ->
    "since 2/15/2016"

Template.dash.events
'click .panel': (event, instance) ->
  console.log 'panel click'
  console.log $(this).data("chart")

Template.dash.onRendered =>
  Meteor.subscribe('flightCounts');
  Meteor.defer () =>
    Meteor.autorun () =>
      # console.log FlightCounts.find().count()
      counts = @FlightCounts.find().fetch()
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