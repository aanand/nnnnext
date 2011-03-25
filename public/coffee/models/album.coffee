class Album extends Backbone.Model
  sync: Backbone.localSync

  rate: (rating) ->
    console.log(rating)
  
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
