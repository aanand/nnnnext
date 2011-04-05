class View extends Backbone.View
  show: ->
    @trigger("show")
    $(@el).show()

  hide: ->
    @trigger("hide")
    $(@el).hide()

  switchView: (viewName) ->
    @views.forEach (v) -> v.hide()
    @currentView = this[viewName]
    @currentView.show()
    @setTabIndex(0) if typeof(@setTabIndex) == 'function'

