if Meteor.isServer
  spaDb = new MongoInternals.RemoteCollectionDriver(process.env.SPA_MONGO_URL)
  @ArticleCounts = new Meteor.Collection("articles", { _driver: spaDb })

if Meteor.isClient
  @ArticleCounts = new Meteor.Collection("articles")
