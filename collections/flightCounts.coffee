@DayCounts = new Meteor.Collection("dayCounts")
if Meteor.isServer
  flirtDB = new MongoInternals.RemoteCollectionDriver("mongodb://172.30.2.95:27017/grits-net-meteor");
  @FlightCounts = new Meteor.Collection("flightCounts", { _driver: flirtDB });

if Meteor.isClient
  @FlightCounts = new Meteor.Collection("flightCounts")
