window.Albums      = new AlbumCollection

class AppView extends Backbone.View
  el: $('#app')

  initialize: ->
    @albumSearch       = new AlbumSearch({queue_collection: Albums})
    @currentAlbumsList = new CurrentAlbumsList({collection: Albums, search: @albumSearch})

    @albumSearch.bind "finishSearch", @currentAlbumsList.hide
    @albumSearch.bind "selectAlbum",  @currentAlbumsList.show

    @el.append(@albumSearch.render().el)
    @el.append(@currentAlbumsList.render().el)

    $(window).keydown (e) => @albumSearch.handleKeypress(e)

    Albums.fetch()

window.App = new AppView
