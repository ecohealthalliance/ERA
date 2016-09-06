Template.articles.onCreated ->
  @articlesReady = new ReactiveVar false
  @diseases = new Meteor.Collection null
  @selectedTab = new ReactiveVar 'Month'
  @selectedDisease = new ReactiveVar null
  Meteor.call 'getDiseaseNames', (err, diseases) =>
    console.log err if err
    for disease in diseases
      @diseases.insert disease: disease

Template.articles.helpers
  diseases: ->
    Template.instance().diseases.find()

  articlesReady: ->
    Template.instance().articlesReady.get()

  selectedTab: (tab) ->
    tab is Template.instance().selectedTab.get()

  selectedDisease: ->
    Template.instance().selectedDisease.get()

Template.articles.events
  "click .time-spans button": (event, template) ->
    template.selectedTab.set template.$(event.target).data 'tab'
    GetDiseaseInfo template

  "change #diseases": (event, template) ->
    template.selectedDisease.set template.$(event.target).val()
    GetDiseaseInfo template

GetDiseaseInfo = (template) ->
  articlesReady = template.articlesReady
  methodName = "getDiseaseInfoBy#{template.selectedTab.get()}"
  articlesReady.set false
  Meteor.call methodName, template.selectedDisease.get(), (err, result) ->
    articlesReady.set true
    CreateDiseaseChart result

CreateDiseaseChart = (counts) ->
  Meteor.defer ->
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
