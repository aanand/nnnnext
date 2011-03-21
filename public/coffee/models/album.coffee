class Album extends Backbone.Model
  clear: ->
    @destroy()
    @view.remove()

class AlbumCollection extends Backbone.Collection
  model: Album,
  url: "/albums"

