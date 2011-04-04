class AlbumList extends Backbone.View
  tagName: 'ul'
  className: 'album-list'

  populate: ->
    $(@el).empty()
    @collection.forEach (album) =>
      $(@el).append(@makeView(album).el)

  makeView: (album) ->
    album.view = new @itemViewClass({model: album, list: this}).render()

_.extend AlbumList.prototype, Tabbable, {
  getTabbableElements: ->
    @collection.map (album) -> album.view.el
}

class SavedAlbumsList extends AlbumList
  itemViewClass: SavedAlbumView
  className: "#{AlbumList.prototype.className} saved-albums-list"

  initialize: (options) ->
    _.bindAll(this, "makeView", "modelSaved")

    @collection.bind "add",        @makeView
    @collection.bind "modelSaved", @modelSaved

  makeView: (album) ->
    view = super(album)
    @showOrHideView(album)
    view

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

class AlbumSearchList extends AlbumList
  itemViewClass: SearchAlbumView
  className: "#{AlbumList.prototype.className} album-search-list"

  populate: ->
    super()

    @newAlbumForm = new NewAlbumForm({nothingFound: (@collection.length == 0)})
    @newAlbumForm.bind "submit", (model) => @trigger("select", model)
    $(@el).append(@newAlbumForm.render().el)

  getTabbableElements: ->
    super().concat(@newAlbumForm.getTabbableElements())

