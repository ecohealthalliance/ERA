BirdCounts = ()->
  @BirdCounts

Template.migrations.onCreated ->
  @subscribe 'birdCounts'
  instance = @
  Meteor.defer () =>
    Meteor.autorun () =>
      birds = BirdCounts().find({}, {sort: {count: -1}, limit: 15}).fetch()
      console.log _.pluck(birds,'bird')
      console.log _.pluck(birds,'count')
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