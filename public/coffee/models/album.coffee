class Album extends Backbone.Model
  sync: Backbone.localSync
  
  clear: ->
    @destroy()
    @view.remove()

class AlbumCollection extends Backbone.Collection
  model: Album

  initialize: (options) ->
    if options?
      @localStorage = options.localStorage
      @sync         = options.sync
