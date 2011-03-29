class Album extends Backbone.Model
  sync: Backbone.localSync

  addTo: (collection) ->
    @collection = collection
    @collection.add(this)

    @update { state: "current" }

  rate: (rating) ->
    @update { rating: rating, state: "archived" }

  delete: ->
    @update { state: "deleted" }

  update: (attrs) ->
    attrs.updated = new Date().getTime()

    if attrs.state? and attrs.state != @get("state")
      attrs.stateChanged = attrs.updated

    @set(attrs)
    @save()

  save: (attrs, options) ->
    if @collection?
      options ||= {}
      originalSuccess = options.success
      options.success = (model, resp) =>
        originalSuccess(model, resp) if originalSuccess?
        @collection.sort()
        @collection.trigger("modelSaved", this)

    super(attrs, options)

class AlbumCollection extends Backbone.Collection
  model: Album

  initialize: (options) ->
    if options?
      @localStorage = options.localStorage
      @sync         = options.sync
      @comparator   = options.comparator
