Template.infoPanel.onCreated ->
  @paneState = @data.paneState

Template.infoPanel.helpers
  active: ()->
    Template.instance().paneState.get() == @chart

Template.infoPanel.events
  'click .info-panel': (event, instance) ->
    instance.paneState.set instance.data.chart
