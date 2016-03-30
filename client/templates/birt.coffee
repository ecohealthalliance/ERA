# BirdCounts = ()->
#   @BirdCounts

# Template.birt.onCreated ->
#   @userData = new ReactiveVar {}
#   @paneState = new ReactiveVar 'bird-chart'
#   @subscribe 'birdCounts'
#   instance = @
#   Meteor.defer () =>
#     Meteor.autorun () =>
#       # console.log BirdCounts().find().fetch()
#       birds = BirdCounts().find().fetch()
#       console.log _.pluck(birds,'bird')
#       console.log _.pluck(birds,'count')
#       Highcharts.chart 'migration-chart',
#         chart:
#             type: 'bar'
#         ,
#         title:
#             text: 'Bird count'
#         ,
#         xAxis:
#             name: 'Species',
#             categories: _.pluck(birds,'bird')
#         ,
#         yAxis:
#             title:
#                 text: 'Number of sightings'
#         ,
#         series: [
#             name: 'Sightings',
#             data: _.pluck(birds,'count')
#         ]