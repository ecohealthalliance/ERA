@DayCounts = new Meteor.Collection("dayCounts")
if Meteor.isServer
  flirtDB = new MongoInternals.RemoteCollectionDriver(process.env.FLIRT_MONGO_URL);
  @FlightCounts = new Meteor.Collection("flightCounts", { _driver: flirtDB });

if Meteor.isClient
  @FlightCounts = new Meteor.Collection("flightCounts")
