class Album extends Backbone.Model
  sync: LocalSync.sync

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
    @collection.trigger("update") if @collection

  removeView: ->
    @view.remove()
    delete @view

