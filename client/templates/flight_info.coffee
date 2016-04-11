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
  airports = AirportCounts().find().fetch()
  arrivalData = _.pluck(airports, "arrivalCount")
  departureData = _.pluck(airports, "departureCount")
  Highcharts.chart 'airport-chart',
      chart:
        type: 'column'
      ,
      title:
        text: 'Arrivals and departures'
      ,
      xAxis:
        name: 'Airport',
        categories: _.pluck(airports,'_id')
      ,
      yAxis:
        title:
          text: 'Arrivals and Departures'
      ,
      plotOptions: 
        series: 
          stacking: 'normal',
        column: 
          pointPadding: 0.2,
          borderWidth: 0
      series: [
          name: 'Arrivals',
          data: arrivalData
        ,
          name: 'Departures',
          data: departureData
      ]
  
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
