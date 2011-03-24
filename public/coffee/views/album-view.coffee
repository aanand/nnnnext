class AlbumView extends Backbone.View
  tagName: 'li'

  events:
    "keypress": "handleKeypress"

  initialize: (options) ->
    @template = options.template
    @list     = options.list

    @model.view = this

  render: ->
    $(@el).html(@template(@model.toJSON()))
    this

  handleKeypress: (e) ->
    return unless e.keyCode == 13
    e.preventDefault()
    @list.trigger("select", @model) if @list?

  remove: ->
    $(@el).remove()

  clear: ->
    @model.clear()

_.extend AlbumView.prototype, Tabbable

