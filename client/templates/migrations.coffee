BirdCounts = ()->
  @BirdCounts

CreateMigrationChart = () ->
  birds = BirdCounts().find().fetch()
  Highcharts.chart 'migration-chart',
    chart:
        type: 'bar'
    ,
    title:
        text: 'Bird count'
    ,
    xAxis:
        name: 'Species',
        categories: _.pluck(birds,'bird')
    ,
    yAxis:
        title:
            text: 'Number of sightings'
    ,
    series: [
        name: 'Sightings',
        data: _.pluck(birds,'count')
    ]

Template.migrations.onRendered ->
  @subscribe 'birdCounts'
  @autorun () =>
    CreateMigrationChart()
