window.CurrentAlbums = new AlbumCollection({
  localStorage: new Store("current-albums")
  sync: Backbone.localSync
})

class AppView extends Backbone.View
  el: $('#app')

  initialize: ->
    CurrentAlbums.fetch()

    @header            = new Header
    @albumSearch       = new AlbumSearch({queueCollection: CurrentAlbums})
    @currentAlbumsList = new CurrentAlbumsList({collection: CurrentAlbums, search: @albumSearch})

    if CurrentAlbums.length > 0
      @header.section = "sign-in"
    else
      @header.section = "intro"

    @albumSearch.bind "finishSearch", @currentAlbumsList.hide
    @albumSearch.bind "selectAlbum",  @currentAlbumsList.show

    CurrentAlbums.bind "add", (album) =>
      album.collection = CurrentAlbums
      # album.sync = CurrentAlbums.sync
      album.save()
      @header.switchTo("sign-in")

    $(window).keydown (e) => @albumSearch.handleKeypress(e)

    @el.append(@header.render().el)
    @el.append(@albumSearch.render().el)
    @el.append(@currentAlbumsList.render().el)

    @currentAlbumsList.populate()

window.App = new AppView
