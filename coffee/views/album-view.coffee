class AlbumView extends View
  tagName: 'li'

  events:
    keypress:  "select"
    mouseover: "showOrHideRating"
    mouseout:  "showOrHideRating"

  initialize: (options) ->
    @list = options.list

  showRating: false
  allowRate: false

  templateVars: -> @model.toJSON()

  render: ->
    $(@el).html(@template(@templateVars()))

    if @showRating
      @$('.controls').append('
        <div class="rate">
          <span data-rating="1"></span><span data-rating="2"></span><span data-rating="3"></span><span data-rating="4"></span><span data-rating="5"></span>
        </div>
      ')

      rating = @model.get("rating")

      if rating?
        stars = @$(".rate span").get()
        $(stars.slice(0, rating)).addClass("rated")

      @showOrHideRating()

    if @allowRate
      $(@el).addClass("allow-rate")

    this

  showOrHideRating: (e) ->
    if @showRating and (@model.get("rating") or ($(@el).is(":hover") and @allowRate))
      @$('.rate').addClass('visible')
    else
      @$('.rate').removeClass('visible')

  focus: (e) ->
    $(@el).focus()

_.extend AlbumView.prototype, Tabbable

class SavedAlbumView extends AlbumView
  template: _.template('
    <div class="controls">
      <div class="delete"></div>
      <% if (state == "archived") { %><div class="restore"></div><% } %>
      <% if (state == "current")  { %><div class="archive"></div><% } %>
    </div>

    <div class="title"><%= title %></div>
    <div class="artist"><%= artist %></div>
  ')

  events:
    _.extend _.clone(AlbumView.prototype.events),
      "mouseover .rate span": "highlightStars"
      "mouseout .rate":       "clearStars"
      "click .rate span":     "rate"
      "click .archive":       "archive"
      "click .restore":       "restore"
      "click .delete":        "delete"

  render: ->
    super()
    $(@el).attr("data-state", state) if state = @model.get("state")
    this

  showRating: true
  allowRate: true

  highlightStars: (e) ->
    @clearStars()
    $(e.target).prevAll().andSelf().addClass("selected")

  clearStars: (e) ->
    @$(".rate span").removeClass("selected")

  rate: (e) ->
    @model.rate(parseInt($(e.target).attr('data-rating')))

  archive: -> @model.archive()
  restore: -> @model.restore()
  delete:  -> @model.delete()

class SearchAlbumView extends AlbumView
  template: _.template('
    <div class="title"><%= title %></div>
    <div class="artist"><%= artist %></div>
  ')

  events:
    _.extend _.clone(AlbumView.prototype.events),
      click: "select"

class FriendsAlbumView extends AlbumView
  template: _.template('
    <div class="controls">
      <div class="add <% if (!inMyList) { %>visible<% } %>"></div>
    </div>

    <div class="title"><%= title %></div>
    <div class="artist"><%= artist %></div>
  ')

  templateVars: ->
    vars = super()
    vars.inMyList = SavedAlbums.any (album) =>
      album.id == @model.id and album.get("state") == "current"

    vars

  events:
    "click .add": "add"

  showRating: true

  add: (e) ->
    @model.unset("state")
    @model.unset("rating")
    @model.addTo(SavedAlbums)
    @$('.add').animate({opacity: 0})
