Template.articles.onCreated ->
  @articlesReady = new ReactiveVar false
  @diseases = new Meteor.Collection null
  @selectedTab = new ReactiveVar 'Month'
  @selectedDisease = new ReactiveVar null

Template.articles.onRendered ->
  instance = @
  Meteor.call 'getDiseaseNames', (err, diseases) ->
    console.log err if err
    for disease in diseases
      instance.diseases.insert disease: disease
    Meteor.defer ->
      instance.$('#diseases').select2
        placeholder: 'Select a disease'

Template.articles.helpers
  diseasesLoaded: ->
    Template.instance().diseases.findOne()

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
    template.selectedTab.set template.$(event.currentTarget).data 'tab'
    GetDiseaseInfo template

  "change #diseases": (event, template) ->
    template.selectedDisease.set template.$(event.target).val()
    GetDiseaseInfo template

GetDiseaseInfo = (template) ->
  articlesReady = template.articlesReady
  time = template.selectedTab.get()
  methodName = "getDiseaseInfoBy#{time}"
  disease = template.selectedDisease.get()
  articlesReady.set false
  Meteor.call methodName, disease, (err, result) ->
    articlesReady.set true
    CreateDiseaseChart result, disease, template.selectedTab.get()

CreateDiseaseChart = (counts, disease, time) ->
  Meteor.defer ->
    Highcharts.chart 'disease-chart',
      chart:
        type: 'column',
        zoomType: 'x'
      ,
      title:
        text: disease
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
        name: "Article density (#{time})",
        data: _.pluck(counts,'number')
      ]
      credits: enabled: false
