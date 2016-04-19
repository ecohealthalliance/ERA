if Meteor.isServer
  flirtDB = new MongoInternals.RemoteCollectionDriver(process.env.FLIRT_MONGO_URL);
  @FlightCounts = new Meteor.Collection("flightCounts", { _driver: flirtDB });
  @DayCounts = new Meteor.Collection("dayCounts", { _driver: flirtDB })

if Meteor.isClient
  @FlightCounts = new Meteor.Collection("flightCounts")
  @DayCounts = new Meteor.Collection("dayCounts")