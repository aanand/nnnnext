class Views.AlbumView extends Views.View
  tagName: 'li'
  className: 'album'

  events:
    keypress:  "select"

  initialize: (options) ->
    @list = options.list

  ratingTemplate: _.template('
    <div class="rate">
      <span data-rating="1">\u2605</span><span data-rating="2">\u2605</span><span data-rating="3">\u2605</span><span data-rating="4">\u2605</span><span data-rating="5">\u2605</span>
    </div>
  ')

  showRating: false
  allowRate: false

  templateVars: -> @model.toJSON()

  render: ->
    $(@el).html(@template(@templateVars()))

    rating = @model.get("rating")

    if @showRating and rating > 0
      @addRatingTo('.info', rating)

    if @allowRate
      @addRatingTo('.controls', rating)

    $(@el).toggleClass('has-rating', (@showRating and rating > 0) or @allowRate)
    $(@el).toggleClass('has-controls', @$('.controls').length > 0)

    if state = @model.get("state")
      $(@el).attr("data-state", state)

    this

  addRatingTo: (selector, rating, method) ->
    e = @$(selector)
    e.prepend(@ratingTemplate())

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
        <% if (state == "archived") { %><div class="restore"></div><% } %>
        <% if (state == "current")  { %><div class="archive"></div><% } %>
        <div class="delete"></div>
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
    $(@el).tappable(callback: (=> @toggleOpen()), touchDelay: TouchDelay)

  render: (options) ->
    super(options)
    rateButton = $("<div class='show-rate-controls'/>")
    rateButton.tappable(@showRateControls)
    @$(".actions").prepend(rateButton)
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

    callback = =>
      $(@el).addClass('touched')
      window.setTimeout((=> @select()), 50)

    $(@el).tappable(callback: callback, touchDelay: TouchDelay)

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
    $(@el).tappable(callback: (=> @toggleOpen()), touchDelay: TouchDelay)

_.extend Touch.FriendsAlbumView.prototype, Views.Openable

