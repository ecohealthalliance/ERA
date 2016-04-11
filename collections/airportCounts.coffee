if Meteor.isServer
  flirtDb = new MongoInternals.RemoteCollectionDriver("mongodb://172.30.2.95:27017/grits-net-meteor");
  @AirportCounts = new Meteor.Collection("airportCounts", { _driver: flirtDb });

if Meteor.isClient
  @AirportCounts = new Meteor.Collection("airportCounts")