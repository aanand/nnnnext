class AlbumCollection extends Backbone.Collection
  model: Album

  initialize: (options) ->
    if options?
      @localStorage = options.localStorage
      @sync         = options.sync

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

