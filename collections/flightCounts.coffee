@DayCounts = new Meteor.Collection("dayCounts")

if Meteor.isServer
  flirtDB = new MongoInternals.RemoteCollectionDriver(
    process.env.FLIRT_MONGO_URL,
    {
      oplogUrl: process.env.FLIRT_MONGO_OPLOG_URL
    })
  @FlightCounts = new Meteor.Collection("flightCounts", { _driver: flirtDB })

if Meteor.isClient
  @FlightCounts = new Meteor.Collection("flightCounts")
