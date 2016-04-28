if Meteor.isServer
  flirtDb = new MongoInternals.RemoteCollectionDriver(
    process.env.FLIRT_MONGO_URL,
    {
      oplogUrl: process.env.FLIRT_MONGO_OPLOG_URL
    })
  @AirportCounts = new Meteor.Collection("airportCounts", { _driver: flirtDb })

if Meteor.isClient
  @AirportCounts = new Meteor.Collection("airportCounts")
