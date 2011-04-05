class Album extends Backbone.Model
  sync: Backbone.localSync

  addTo: (collection) ->
    @collection = collection
    @collection.add(this)

    @update { state: "current" }

  rate: (rating) ->
    @update { rating: rating }

  archive: -> @update { state: "archived" }
  restore: -> @update { state: "current"  }
  delete:  -> @update { state: "deleted"  }

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

  destroy: (options) ->
    coll = @collection

    if coll?
      options ||= {}
      originalSuccess = options.success
      options.success = (model, resp) =>
        originalSuccess(model, resp) if originalSuccess?
        coll.trigger("modelDestroyed", this)

    super(options)

class AlbumCollection extends Backbone.Collection
  model: Album

  initialize: (options) ->
    if options?
      @localStorage = options.localStorage
      @sync         = options.sync
      @comparator   = options.comparator

  deDupe: ->
    map = {}

    @models.forEach (album) ->
      dupe = map[album.id]

      if dupe?
        if album.get("updated") < dupe.get("updated")
          console.log "Destroying old duplicate of album #{album.id} (#{album.get("updated")} < #{dupe.get("updated")})"
          album.destroy()
        else
          console.log "Destroying old duplicate of album #{album.id} (#{dupe.get("updated")} < #{album.get("updated")})"
          dupe.destroy()
          map[album.id] = album
      else
        map[album.id] = album

