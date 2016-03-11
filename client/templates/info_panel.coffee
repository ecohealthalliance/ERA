Template.infoPanel.events
  'click .panel': (event, instance) ->
    $(".info-panel").removeClass("active")
    $(event.currentTarget).addClass("active")
    chart = event.currentTarget.getAttribute("data-chart")
    $(".chart").hide()
    $("#" + chart).show()

