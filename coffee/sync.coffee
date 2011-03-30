Sync =
  start: (collection, url) ->
    json = JSON.stringify(collection.models.map (a) -> a.attributes)

    $.ajax
      type:        "POST"
      url:         url
      contentType: "application/json"
      data:        json
      success:     (albums) => @sync(collection, albums, url)

  sync: (collection, serverAlbums, url) ->
    resync = false

    serverAlbums.forEach (serverAlbum) =>
      clientAlbum = collection.get(serverAlbum.id)

      if clientAlbum?
        updatedOnClient = clientAlbum.get("updated")

        if updatedOnClient < serverAlbum.updated
          console.log "Album #{serverAlbum.id} is behind on client (#{updatedOnClient} < #{serverAlbum.updated}). Updating."
          clientAlbum.set(serverAlbum)
          clientAlbum.save()
        else if updatedOnClient > serverAlbum.updated
          console.log "Album #{serverAlbum.id} is behind on server. (#{updatedOnClient} > #{serverAlbum.updated}) Going to re-sync."
          resync = true
        else
          console.log "Album #{serverAlbum.id} is in sync (#{updatedOnClient} == #{serverAlbum.updated})."
      else
        console.log "Album #{serverAlbum.id} does not exist on client. Creating."
        clientAlbum = collection.create(serverAlbum)

    if resync
      @start(collection, url)
    else
      @trigger("finish")

_.extend(Sync, Backbone.Events)

