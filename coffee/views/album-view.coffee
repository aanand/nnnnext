class Views.AlbumView extends Views.View
  tagName: 'li'
  className: 'album'

  events:
    keypress:  "select"

  initialize: (options) ->
    @list = options.list

  ratingTemplate: _.template('
    <div class="rate">
      <span data-rating="1"></span><span data-rating="2"></span><span data-rating="3"></span><span data-rating="4"></span><span data-rating="5"></span>
    </div>
  ')

  showRating: false
  allowRate: false

  templateVars: -> @model.toJSON()

  render: ->
    $(@el).html(@template(@templateVars()))

    rating = @model.get("rating")

    if @showRating and rating > 0
      @addRatingTo('.info', rating, 'prepend')

    if @allowRate
      @addRatingTo('.controls', rating, 'append')

    if state = @model.get("state")
      $(@el).attr("data-state", state)

    this

  addRatingTo: (selector, rating, method) ->
    e = @$(selector)
    e[method](@ratingTemplate())

    if rating?
      stars = e.find(".rate span").get()
      $(stars.slice(0, rating)).addClass("rated")

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
      <div class="actions">
        <div class="delete"></div>
        <% if (state == "archived") { %><div class="restore"></div><% } %>
        <% if (state == "current")  { %><div class="archive"></div><% } %>
      </div>
    </div>
  ')

  events:
    _.extend _.clone(Views.AlbumView.prototype.events),
      "mouseover .controls .rate span": "highlightStars"
      "mouseout .controls .rate":       "clearStars"

  initialize: (options) ->
    super(options)
    _.bindAll(this, "rate", "archive", "restore", "delete")

  render: ->
    super()
    @$(".rate span").tappable(@rate)
    @$(".archive").tappable(@archive)
    @$(".restore").tappable(@restore)
    @$(".delete").tappable(@delete)
    this

  showRating: true
  allowRate: true

  highlightStars: (e) ->
    @clearStars()

    $(e.target).prevAll().andSelf()
      .addClass("selected")
      .removeClass("not-selected")

    $(e.target).nextAll()
      .removeClass("selected")
      .addClass("not-selected")

  clearStars: (e) ->
    @$(".rate span")
      .removeClass("selected")
      .removeClass("not-selected")

  rate: (e) ->
    @model.rate(parseInt($(e.target).attr('data-rating')))

  archive: -> @model.archive()
  restore: -> @model.restore()
  delete:  -> @model.delete()

class Touch.SavedAlbumView extends Views.SavedAlbumView
  initialize: (options) ->
    super(options)
    _.bindAll(this, "showRateControls")
    $(@el).tappable => @toggleOpen()

  render: (options) ->
    super(options)
    rateButton = $("<div class='show-rate-controls'/>")
    rateButton.tappable(@showRateControls)
    @$(".actions").append(rateButton)
    this

  showRateControls: (e) ->
    e.stopPropagation()
    @open()
    $(@el).addClass('showing-rate-controls')

  hideRateControls: ->
    $(@el).removeClass('showing-rate-controls')

_.extend Touch.SavedAlbumView.prototype, Views.Openable,
  onClose: -> @hideRateControls()

class Views.SearchAlbumView extends Views.AlbumView
  template: _.template('
    <div class="info">
      <div class="title"><%= title %></div>
      <div class="artist"><%= artist %></div>
    </div>
  ')

  events:
    _.extend _.clone(Views.AlbumView.prototype.events),
      click: "select"

class Touch.SearchAlbumView extends Views.SearchAlbumView
  initialize: (options) ->
    super(options)
    $(@el).tappable => @select()

class Views.FriendsAlbumView extends Views.AlbumView
  template: _.template('
    <div class="info">
      <div class="title"><%= title %></div>
      <div class="artist"><%= artist %></div>
    </div>

    <div class="controls">
      <div class="actions">
        <div class="add"/>
      </div>
    </div>
  ')

  initialize: (options) ->
    super(options)
    @inMyListCheck()

  inMyListCheck: ->
    @inMyList = SavedAlbums.any (album) =>
      album.id == @model.id and album.get("state") == "current"

    if @inMyList
      $(@el).addClass("in-my-list")
    else
      $(@el).removeClass("in-my-list")

  render: ->
    super()

    @$(".add").tappable
      callback: => @add()
      onlyIf:   => !@inMyList

    this

  showRating: true

  add: ->
    album = new Album({
      id:     @model.id
      artist: @model.get("artist")
      title:  @model.get("title")
    })

    album.addTo(SavedAlbums)

    @inMyListCheck()

class Touch.FriendsAlbumView extends Views.FriendsAlbumView
  initialize: (options) ->
    super(options)
    $(@el).tappable => @toggleOpen()

_.extend Touch.FriendsAlbumView.prototype, Views.Openable

