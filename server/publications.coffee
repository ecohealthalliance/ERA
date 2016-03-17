Meteor.publish 'flightCounts', =>
  @FlightCounts.find({},{sort: {date: 1}})