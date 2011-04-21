class Views.AlbumView extends Views.View
  tagName: 'li'
  className: 'album'

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
    <div class="info">
      <div class="title"><%= title %></div>
      <div class="artist"><%= artist %></div>
    </div>

    <div class="controls">
      <div class="delete"></div>
      <% if (state == "archived") { %><div class="restore"></div><% } %>
      <% if (state == "current")  { %><div class="archive"></div><% } %>
    </div>
  ')

  events:
    _.extend _.clone(Views.AlbumView.prototype.events),
      "mouseover .rate span": "highlightStars"
      "mouseout .rate":       "clearStars"

  initialize: (options) ->
    super(options)
    _.bindAll(this, "rate", "archive", "restore", "delete")

  render: ->
    super()
    @$(".rate span").tap(@rate)
    @$(".archive").tap(@archive)
    @$(".restore").tap(@restore)
    @$(".delete").tap(@delete)
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

class Touch.SavedAlbumView extends Views.SavedAlbumView
  initialize: (options) ->
    super(options)
    $(@el).tap => @toggleOpen()
    @list.bind "scroll", (isScrolling) => @close() if isScrolling

  toggleOpen: ->
    if $(@el).hasClass('open')
      @close()
    else
      @open()

  open: ->
    $(@el).addClass('open')
    @list.albumOpened(this.model)

  close: ->
    $(@el).removeClass('open')

class Views.SearchAlbumView extends Views.AlbumView
  template: _.template('
    <div class="title"><%= title %></div>
    <div class="artist"><%= artist %></div>
  ')

  events:
    _.extend _.clone(Views.AlbumView.prototype.events),
      click: "select"

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
