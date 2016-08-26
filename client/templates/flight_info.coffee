FlightCounts = ->
  @FlightCounts
DayCounts = ->
  @DayCounts
AirportCounts = ->
  @AirportCounts
HistoricalData = ->
  @HistoricalData


CreateDaysChart = ->
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

CreateAirportChart = ->
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
        categories: _.pluck(airports, '_id')
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

CreateFlightCountChart = ->
  counts = FlightCounts().find().fetch()
  cleanDates = _.map counts, (item) ->
    return { date: item.date.toLocaleDateString(), count: item.count }
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
  @lastTwoUpdates = new ReactiveVar false
  @flightCountsSubHandle = @subscribe 'flightCounts'
  @dayCountsSubHandle = @subscribe 'dayCounts'
  @airportCountsSubHandle = @subscribe 'airportCounts'
  @historicalDataSubHandle = @subscribe 'historicalData'

Template.flightInfo.helpers
  currentDate: ->
    history = Template.instance().lastTwoUpdates.get()
    if history
      moment(history[0].date).format("MM/D/YYYY")

  previousDate: ->
    history = Template.instance().lastTwoUpdates.get()
    if history
      moment(history[1].date).format("MM/D/YYYY")

  currentLegCount: ->
    history = Template.instance().lastTwoUpdates.get()
    if history
      history[0].counts.legs + " legs"

  previousLegCount: ->
    history = Template.instance().lastTwoUpdates.get()
    if history
      history[1].counts.legs + " legs"

  currentFlightCount: ->
    history = Template.instance().lastTwoUpdates.get()
    if history
      history[0].counts.flights + " flights"

  previousFlightCount: ->
    history = Template.instance().lastTwoUpdates.get()
    if history
      history[1].counts.flights + " flights"

  legsAdded: ->
    history = Template.instance().lastTwoUpdates.get()
    if history
      history[0].counts.legs - history[1].counts.legs

  flightsAdded: ->
    history = Template.instance().lastTwoUpdates.get()
    if history
      history[0].counts.flights - history[1].counts.flights

Template.flightInfo.onRendered ->
  # Render placeholders
  CreateFlightCountChart()
  CreateDaysChart()
  CreateAirportChart()
  # Re-render using the actual data
  @autorun =>
    if @flightCountsSubHandle.ready()
      CreateFlightCountChart()

    if @dayCountsSubHandle.ready()
      CreateDaysChart()

    if @airportCountsSubHandle.ready()
      CreateAirportChart()

    if @historicalDataSubHandle.ready()
      lastTwoUpdates = HistoricalData().find({}, {sort: {date: -1}, take: 2}).fetch()
      # console.log lastTwoUpdates
      Template.instance().lastTwoUpdates.set(lastTwoUpdates)
