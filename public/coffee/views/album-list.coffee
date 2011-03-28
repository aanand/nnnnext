class AlbumList extends Backbone.View
  tagName: 'ul'
  className: 'album-list'

  initialize: (options) ->
    _.bindAll(this, "updateAlbum", "populate", "show", "hide")

    @collection.bind "modelSaved", @updateAlbum
    @collection.bind "refresh", @populate

  updateAlbum: (album) ->
    if album.view?
      @updateAlbumView(album)
    else
      album.view = new @itemViewClass({model: album, list: this})
      @updateAlbumView(album)

      albumEl  = $(album.view.el)
      index    = @collection.indexOf(album)
      children = $(@el).children()

      if children[index]
        albumEl.insertBefore(children[index])
      else
        albumEl.appendTo(@el)

  populate: ->
    $(@el).empty()
    @collection.forEach (album) => @updateAlbum(album)

  filter: (state) ->
    @filterState = state

    @collection.forEach (album) =>
      @updateAlbumView(album)

  updateAlbumView: (album) ->
    album.view.render()

    return unless @filterState?

    if album.get("state") == @filterState
      album.view.show()
    else
      album.view.hide()

  show: -> $(@el).show()
  hide: -> $(@el).hide()

_.extend AlbumList.prototype, Tabbable, {
  getTabbableElements: ->
    @collection.map (album) -> album.view.el
}

class SavedAlbumsList extends AlbumList
  itemViewClass: SavedAlbumView
  className: "#{AlbumList.prototype.className} saved-albums-list"

class AlbumSearchList extends AlbumList
  itemViewClass: SearchAlbumView
  className: "#{AlbumList.prototype.className} album-search-list"

