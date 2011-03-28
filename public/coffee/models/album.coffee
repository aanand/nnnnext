class Album extends Backbone.Model
  sync: Backbone.localSync

  addTo: (collection) ->
    @view = null
    @collection = collection
    @collection.add(this)

    @set {
      state:   "current"
      updated: new Date().getTime()
    }

    @save()

  rate: (rating) ->
    @set {
      rating:  rating
      state:   "archived"
      updated: new Date().getTime()
    }

    @save()

  delete: ->
    @set {
      state:   "deleted"
      updated: new Date().getTime()
    }

    @save()

  save: (attrs, options) ->
    if @collection?
      options ||= {}
      originalSuccess = options.success
      options.success = (model, resp) =>
        originalSuccess(model, resp) if originalSuccess?
        @collection.trigger("modelSaved", this)

    super(attrs, options)

class AlbumCollection extends Backbone.Collection
  model: Album

  initialize: (options) ->
    if options?
      @localStorage = options.localStorage
      @sync         = options.sync
      @comparator   = options.comparator

