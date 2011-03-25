class AlbumView extends Backbone.View
  tagName: 'li'

  events:
    "keypress": "handleKeypress"
    "click": "focus"

  initialize: (options) ->
    @list = options.list
    @model.view = this

  render: ->
    $(@el).html(@template(@model.toJSON()))
    this

  handleKeypress: (e) ->
    return unless e.keyCode == 13
    e.preventDefault()
    @select()

  focus: (e) ->
    $(@el).focus()

  select: ->
    @list.trigger("select", @model) if @list?

  remove: ->
    $(@el).remove()

  clear: ->
    @model.clear()

_.extend AlbumView.prototype, Tabbable

class CurrentAlbumView extends AlbumView
  template: _.template('
    <div class="controls">
      <div class="rate">
        <span data-rating="1"></span><span data-rating="2"></span><span data-rating="3"></span><span data-rating="4"></span><span data-rating="5"></span>
      </div>
      <div class="delete"></div>
    </div>
    <div class="title"><%= title %></div>
    <div class="artist"><%= artist %></div>
  ')

  events:
    _.extend _.clone(AlbumView.prototype.events),
      "mouseover .rate span": "highlightStars"
      "mouseout .rate":       "clearStars"
      "click .rate span":     "rate"
      "click .delete":        "delete"

  highlightStars: (e) ->
    @clearStars()
    $(e.target).prevAll().andSelf().addClass("selected")

  clearStars: (e) ->
    @$(".rate span").removeClass("selected")

  rate: (e) ->
    @model.rate(parseInt($(e.target).attr('data-rating')))

  delete: ->
    @model.clear()

class SearchAlbumView extends AlbumView
  template: _.template('
    <div class="title"><%= title %></div>
    <div class="artist"><%= artist %></div>
  ')

  events:
    _.extend _.clone(AlbumView.prototype.events),
      "click": "select"
