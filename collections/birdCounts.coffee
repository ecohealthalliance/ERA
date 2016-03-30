if Meteor.isServer
  birtDB = new MongoInternals.RemoteCollectionDriver("mongodb://localhost/birt");
  @BirdCounts = new Meteor.Collection("birdCounts", { _driver: birtDB });

if Meteor.isClient
  @BirdCounts = new Meteor.Collection("birdCounts")