if Meteor.isServer
  flirtDB = new MongoInternals.RemoteCollectionDriver(process.env.FLIRT_MONGO_URL)
  @FlightCounts = new Meteor.Collection("flightCounts", { _driver: flirtDB })
  @DayCounts = new Meteor.Collection("dayCounts", { _driver: flirtDB })
  # Since these are used to get counts for the entire collection we only
  # want them on the sever side, otherwise we are overpublishing
  @FlightTotals = new Meteor.Collection("flights", { _driver: flirtDB })
  @LegTotals = new Meteor.Collection("legs", { _driver: flirtDB })

if Meteor.isClient
  @FlightCounts = new Meteor.Collection("flightCounts")
  @DayCounts = new Meteor.Collection("dayCounts")
