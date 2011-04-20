class Views.AlbumList extends Views.View
  tagName: 'ul'
  className: 'album-list'

  initialize: (options) ->
    _.bindAll(this, "populate")

  populate: ->
    $(@el).empty()
    @collection.forEach (album) =>
      $(@el).append(@makeView(album).render().el)

  makeView: (album) ->
    album.view = new UI[@itemViewClassName]({model: album, list: this})

_.extend Views.AlbumList.prototype, Views.Tabbable, {
  getTabbableElements: ->
    @collection.map (album) -> album.view.el
}

class Views.SavedAlbumsList extends Views.AlbumList
  itemViewClassName: 'SavedAlbumView'
  className: "#{Views.AlbumList.prototype.className} saved-albums-list"

  initialize: (options) ->
    super(options)

    _.bindAll(this, "add", "remove", "change")

    @collection.bind "add",     @add
    @collection.bind "refresh", @populate
    @collection.bind "remove",  @remove
    @collection.bind "change",  @change

    $(@el).isScrollable (isScrolling) =>
      @trigger("scroll", isScrolling)

  add: (album) ->
    album.removeView() if album.view? and album.view.el.parentNode != @el
    @makeView(album).render()
    $(@el).insertAt(album.view.el, @collection.indexOf(album))

  remove: (album) ->
    album.removeView() if album.view? and album.view.el.parentNode == @el

  change: (album) ->
    album.view.render() if album.view?

class Touch.SavedAlbumsList extends Views.SavedAlbumsList
  albumOpened: (album) ->
    for a in @collection.models
      if a != album
        a.view.close()

class Views.AlbumSearchList extends Views.AlbumList
  itemViewClassName: 'SearchAlbumView'
  className: "#{Views.AlbumList.prototype.className} album-search-list"

  populate: ->
    super()

    @newAlbumForm = new UI.NewAlbumForm({nothingFound: (@collection.length == 0)})
    @newAlbumForm.bind "submit", (model) => @trigger("select", model)
    $(@el).append(@newAlbumForm.render().el)

  getTabbableElements: ->
    super().concat(@newAlbumForm)

class Views.FriendsAlbumsList extends Views.AlbumList
  itemViewClassName: 'FriendsAlbumView'
  className: "#{Views.AlbumList.prototype.className} friends-albums-list"

  initialize: (options) ->
    super(options)
    @collection.bind "refresh", @populate

  populate: ->
    super()

    if @collection.length == 0
      $(@el).append("<li class='nothing-found'>#{@user.get("nickname")} doesn’t have any albums queued.</li>")

    if @user?
      userView = new UI.FriendView({model: @user, highlightable: false, backButton: true})
      userView.bind "back", => @trigger("back")
      $(@el).prepend(userView.render().el)

