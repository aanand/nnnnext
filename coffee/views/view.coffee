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
    @reTab() if typeof(@reTab) == 'function'

  select: (e) ->
    if e?
      return if e.type == "keypress" and e.keyCode != 13
      e.preventDefault()

    @list.trigger("select", @model) if @list?
