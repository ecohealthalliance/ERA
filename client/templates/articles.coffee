Template.articles.onCreated ->
  @articlesReady = new ReactiveVar false
  @diseases = new ReactiveVar false
  Modal.show("loadingModal")
  Meteor.call 'getDiseaseNames', (err, result) =>
    console.log err if err
    Modal.hide()
    @diseases.set result

Template.articles.helpers
  diseases: ->
    Template.instance().diseases.get()

  articlesReady: ->
    Template.instance().articlesReady.get()

Template.articles.events

  "click .block": (event, template) ->
    $(".block").removeClass("current")
    $(event.target).addClass("current")

  "change #diseases": (event, template) =>
    $(".block").removeClass("current")
    $(".month").addClass("current")
    Modal.show("loadingModal")
    Meteor.call 'getDiseaseInfoByMonth', $("#diseases").val(), (err, result) =>
      template.articlesReady.set(true)
      CreateDiseaseChart(result)
      Modal.hide()

  "click .day": (event, template) ->
    Modal.show("loadingModal")
    Meteor.call 'getDiseaseInfoByDay', $("#diseases").val(), (err, result) ->
      template.articlesReady.set(true)
      CreateDiseaseChart(result)
      Modal.hide()

  "click .week": (event, template) ->
    Modal.show("loadingModal")
    Meteor.call 'getDiseaseInfoByWeek', $("#diseases").val(), (err, result) ->
      template.articlesReady.set(true)
      CreateDiseaseChart(result)
      Modal.hide()

  "click .month": (event, template) ->
    Modal.show("loadingModal")
    Meteor.call 'getDiseaseInfoByMonth', $("#diseases").val(), (err, result) ->
      template.articlesReady.set(true)
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
