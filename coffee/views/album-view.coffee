class Views.AlbumView extends Views.View
  tagName: 'li'
  className: 'album'

  events:
    keypress:  "select"
    mouseover: "showOrHideRating"
    mouseout:  "showOrHideRating"
    focus:     "highlight"
    blur:      "highlight"

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

    if state = @model.get("state")
      $(@el).attr("data-state", state)

    this

  showOrHideRating: (e) ->
    if @showRating and (@model.get("rating") or ($(@el).is(":hover") and @allowRate))
      @$('.rate').addClass('visible')
    else
      @$('.rate').removeClass('visible')

  focus: (e) ->
    $(@el).focus()

_.extend Views.AlbumView.prototype, Views.Tabbable

class Views.SavedAlbumView extends Views.AlbumView
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
    _.extend _.clone(Views.AlbumView.prototype.events),
      "mouseover .rate span": "highlightStars"
      "mouseout .rate":       "clearStars"
      "click .rate span":     "rate"
      "click .archive":       "archive"
      "click .restore":       "restore"
      "click .delete":        "delete"

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

class Touch.SavedAlbumView extends Views.SavedAlbumView
  events:
    _.extend _.clone(Views.SavedAlbumView.prototype.events),
      "touchstart": "ontouchstart"
      "touchmove":  "ontouchmove"
      "touchend":   "ontouchend"

  ontouchstart: ->
    @touchmoved = false
    $(@el).addClass('active')
    true

  ontouchmove: ->
    unless @touchmoved
      @touchmoved = true
      $(@el).removeClass('active')
    true

  ontouchend: ->
    unless @touchmoved
      console.log "touched"
      $(@el).removeClass('active')
    true

class Views.SearchAlbumView extends Views.AlbumView
  template: _.template('
    <div class="title"><%= title %></div>
    <div class="artist"><%= artist %></div>
  ')

  events:
    _.extend _.clone(Views.AlbumView.prototype.events),
      click: "select"
      mouseover: "highlight"
      mouseout:  "highlight"

class Views.FriendsAlbumView extends Views.AlbumView
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
    _.extend _.clone(Views.AlbumView.prototype.events),
      "click .add": "add"

  showRating: true

  add: (e) ->
    album = new Album({
      id:     @model.id
      artist: @model.get("artist")
      title:  @model.get("title")
    })

    album.addTo(SavedAlbums)

    @$('.add').animate({opacity: 0})
