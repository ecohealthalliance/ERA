Meteor.publish 'flightCounts', =>
  @FlightCounts.find()

Meteor.publish 'birdCounts', =>
  @BirdCounts.find({count: {$gt: 45}})