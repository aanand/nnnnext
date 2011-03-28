class AlbumView extends Backbone.View
  tagName: 'li'

  events:
    "keypress": "handleKeypress"

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

class SavedAlbumView extends AlbumView
  template: _.template('
    <div class="rate">
      <span data-rating="1"></span><span data-rating="2"></span><span data-rating="3"></span><span data-rating="4"></span><span data-rating="5"></span>
    </div>
    <div class="delete"></div>
    <div class="title"><%= title %></div>
    <div class="artist"><%= artist %></div>
  ')

  events:
    _.extend _.clone(AlbumView.prototype.events),
      "mouseover .rate span": "highlightStars"
      "mouseout .rate":       "clearStars"
      "click .rate span":     "rate"
      "click .delete":        "delete"

  render: ->
    super()

    rating = @model.get("rating")

    if rating?
      stars = @$(".rate span").get()

      $(@el).addClass("has-rating")
      $(stars.slice(0, rating)).addClass("rated")

    this

  highlightStars: (e) ->
    @clearStars()
    $(e.target).prevAll().andSelf().addClass("selected")

  clearStars: (e) ->
    @$(".rate span").removeClass("selected")

  rate: (e) ->
    @model.rate(parseInt($(e.target).attr('data-rating')))

  delete: ->
    @model.delete()

  show: -> $(@el).show()
  hide: -> $(@el).hide()

class SearchAlbumView extends AlbumView
  template: _.template('
    <div class="title"><%= title %></div>
    <div class="artist"><%= artist %></div>
  ')

  events:
    _.extend _.clone(AlbumView.prototype.events),
      "click": "select"
