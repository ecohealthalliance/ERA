Template.articles.onCreated ->
  @articleCounts = new ReactiveVar 0
  @diseases = new ReactiveVar false
  Modal.show("loadingModal")
  Meteor.call 'getDiseaseNames', (err, result) =>
    console.log err if err
    Modal.hide()
    @diseases.set result

Template.articles.helpers
  diseases: ->
    Template.instance().diseases.get()

Template.articles.events
  "change #diseases": (event) ->
    Modal.show("loadingModal")
    Meteor.call 'getDiseaseInfo', $(event.target).val(), (err, result) ->
      CreateDiseaseChart(result)
      Modal.hide()

CreateDiseaseChart = (counts) ->
    Highcharts.chart 'disease-chart',
      chart:
        type: 'column',
        zoomType: 'x'
      ,
      title:
        text: 'Article count'
      ,
      xAxis:
        name: 'Date',
        categories: _.pluck(counts,'_id')
      ,
      yAxis:
        title:
          text: 'Article count'
      ,
      series: [
        name: 'Article density',
        data: _.pluck(counts,'number')
      ]