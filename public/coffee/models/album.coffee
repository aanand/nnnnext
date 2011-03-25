class Album extends Backbone.Model
  sync: Backbone.localSync

  rate: (rating) ->
    if @collection == CurrentAlbums
      @clear()
      ArchivedAlbums.add(this)

    @set({"rating": rating, "archived": new Date().getTime()})
    @save()
    @view.render()
  
  clear: ->
    @destroy()
    @view.remove()

class AlbumCollection extends Backbone.Collection
  model: Album

  initialize: (options) ->
    if options?
      @localStorage = options.localStorage
      @sync         = options.sync
      @comparator   = options.comparator

CurrentAlbums = new AlbumCollection({
  localStorage: new Store("current-albums")
  sync: Backbone.localSync
  comparator: (a) -> -a.get("added")
})

ArchivedAlbums = new AlbumCollection({
  localStorage: new Store("archived-albums")
  sync: Backbone.localSync
  comparator: (a) -> -a.get("added")
})

