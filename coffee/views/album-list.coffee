class AlbumList extends View
  tagName: 'ul'
  className: 'album-list'

  initialize: (options) ->
    _.bindAll(this, "populate")

  populate: ->
    $(@el).empty()
    @collection.forEach (album) =>
      $(@el).append(@makeView(album).render().el)

  makeView: (album) ->
    album.view = new @itemViewClass({model: album, list: this})

_.extend AlbumList.prototype, Tabbable, {
  getTabbableElements: ->
    @collection.map (album) -> album.view.el
}

class SavedAlbumsList extends AlbumList
  itemViewClass: SavedAlbumView
  className: "#{AlbumList.prototype.className} saved-albums-list"

  initialize: (options) ->
    super(options)

    _.bindAll(this, "makeView", "modelSaved")

    @collection.bind "add",        @makeView
    @collection.bind "modelSaved", @modelSaved
    @collection.bind "modelDestroyed", @modelDestroyed

  filter: (state) ->
    @filterState = state

    @collection.forEach (album) =>
      @showOrHideView(album)

  showOrHideView: (album) ->
    return unless @filterState?

    if album.get("state") == @filterState
      album.view.show()
    else
      album.view.hide()

  modelSaved: (album) ->
    album.view.render()
    @showOrHideView(album)

    albumEl      = album.view.el
    correctIndex = @collection.indexOf(album)
    currentIndex = $(@el).children().get().indexOf(albumEl)

    if currentIndex != correctIndex
      @el.removeChild(albumEl) if currentIndex != -1

      childToInsertBefore = $(@el).children()[correctIndex]

      if childToInsertBefore?
        $(albumEl).insertBefore(childToInsertBefore)
      else
        $(albumEl).appendTo(@el)

  modelDestroyed: (album) ->
    album.view.remove() if album.view?

class AlbumSearchList extends AlbumList
  itemViewClass: SearchAlbumView
  className: "#{AlbumList.prototype.className} album-search-list"

  populate: ->
    super()

    @newAlbumForm = new NewAlbumForm({nothingFound: (@collection.length == 0)})
    @newAlbumForm.bind "submit", (model) => @trigger("select", model)
    $(@el).append(@newAlbumForm.render().el)

  getTabbableElements: ->
    super().concat(@newAlbumForm)

class FriendsAlbumsList extends AlbumList
  itemViewClass: FriendsAlbumView
  className: "#{AlbumList.prototype.className} friends-albums-list"

  initialize: (options) ->
    super(options)
    @collection.bind "refresh", @populate

  populate: ->
    super()

    if @user?
      userView = new FriendView({model: @user, highlightable: false})
      $(@el).prepend(userView.render().el)

