class Views.List extends Views.View
  tagName: 'ul'

  initialize: (options) ->
    _.bindAll(this, "populate")

  populate: ->
    $(@el).empty()

    @collection.forEach (model) =>
      $(@el).append(@makeView(model).render().el)

    @reTab()

  setHint: (hint) ->
    if @hint?
      @hint.remove()
      @$(".hint-container").remove()

    @hint = hint
    @appendHint(@hint) if @hint?

  appendHint: (hint) ->
    $('<li class="hint-container"/>').append(hint.render().el).appendTo(@el)

_.extend Views.List.prototype, Views.Tabbable,
  getTabbableElements: -> @collection.models.map (m) -> m.view.el

