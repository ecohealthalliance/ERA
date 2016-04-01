if Meteor.isServer
  flirtDb = new MongoInternals.RemoteCollectionDriver("mongodb://localhost/grits-net-meteor");
  @AirportCounts = new Meteor.Collection("airportCounts", { _driver: flirtDb });

if Meteor.isClient
  @AirportCounts = new Meteor.Collection("airportCounts")