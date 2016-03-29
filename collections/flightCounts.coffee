if Meteor.isServer
  flirtDB = new MongoInternals.RemoteCollectionDriver("mongodb://localhost/grits-net-meteor");
  @FlightCounts = new Meteor.Collection("flightCounts", { _driver: flirtDB });

if Meteor.isClient
  @FlightCounts = new Meteor.Collection("flightCounts")