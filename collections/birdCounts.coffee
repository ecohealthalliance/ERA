if Meteor.isServer
  birtDB = new MongoInternals.RemoteCollectionDriver(
    process.env.BIRT_MONGO_URL,
    {
      oplogUrl: process.env.BIRT_MONGO_OPLOG_URL
    })
  @BirdCounts = new Meteor.Collection("birdCounts", { _driver: birtDB })

if Meteor.isClient
  @BirdCounts = new Meteor.Collection("birdCounts")
