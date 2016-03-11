Meteor.publish 'flightCounts', =>
  @FlightCounts.find()