if Meteor.isServer
  birtDB = new MongoInternals.RemoteCollectionDriver("mongodb://172.30.2.95:27017/birt");
  @BirdCounts = new Meteor.Collection("birdCounts", { _driver: birtDB });

if Meteor.isClient
  @BirdCounts = new Meteor.Collection("birdCounts")