FlightCounts = ()->
  @FlightCounts
DayCounts = ()->
  @DayCounts
AirportCounts = ()->
  @AirportCounts

CreateDaysChart = () ->
  counts = DayCounts().find().fetch()
  Highcharts.chart 'day-chart',
      chart:
          type: 'bar'
      ,
      title:
          text: 'Flights per day of week'
      ,
      xAxis:
          name: 'Day of week',
          categories: _.pluck(counts,'day')
      ,
      yAxis:
          title:
              text: 'Number of Flights'
      ,
      series: [
          name: 'Flights per day of week',
          data: _.pluck(counts,'count')
      ]

CreateAirportChart = () ->
  console.log AirportCounts().find().fetch()

CreateFlightCountChart = () ->
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

Template.flightInfo.onCreated ->
  Meteor.defer () =>
    Meteor.autorun () =>
      CreateFlightCountChart()
      CreateDaysChart()
      CreateAirportChart()
