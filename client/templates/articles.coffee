Template.articles.onCreated ->
  # @subscribe 'articleCounts'
  @articleCounts = new ReactiveVar {}
  @autorun =>
    Meteor.call 'getArticleCounts', (err, result) =>
      console.log 'returned from method call', result
      @articleCounts.set result

# ArticleCounts = ->
#   console.log(@ArticleCounts)
#   @ArticleCounts

Template.articles.helpers
  articleCount: ->
    console.log 'inside articleCount helper', @articleCounts
    # @articleCounts
    'test'
