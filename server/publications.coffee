Meteor.publish 'flightCounts', =>
  # assuming that data with counts less than 10,000 are junk data that doesn't need to be displayed
  @FlightCounts.find({count: {$gt: 10000}},{sort: {date: 1}})

Meteor.publish 'dayCounts', =>
  @DayCounts.find({},{sort: {date: 1}})

Meteor.publish 'birdCounts', =>
  @BirdCounts.find({count: {$gt: 45}})
