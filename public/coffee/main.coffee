window.AlbumSearchResults = new AlbumCollection

class AppView extends Backbone.View
  el: $('#app')

  initialize: ->
    CurrentAlbums.fetch()
    ArchivedAlbums.fetch()

    @header = new Header
    @header.href = "/current"

    if CurrentAlbums.length > 0 or ArchivedAlbums.length > 0
      @header.section = "nav"
    else
      @header.section = "intro"

    @searchBar          = new AlbumSearchBar({collection: AlbumSearchResults})
    @searchResultsList  = new AlbumSearchList({collection: AlbumSearchResults})
    @currentAlbumsList  = new CurrentAlbumsList({collection: CurrentAlbums})
    @archivedAlbumsList = new CurrentAlbumsList({collection: ArchivedAlbums})

    @lists = [@searchResultsList, @currentAlbumsList, @archivedAlbumsList]

    _.bindAll(this, "navigate", "addAlbum", "startSearch", "finishSearch", "handleKeypress")

    @header.bind            "navigate", @navigate
    @searchBar.bind         "submit",  @startSearch
    @searchResultsList.bind "select",  @addAlbum
    AlbumSearchResults.bind "refresh", @finishSearch
    $(window).bind          "keydown", @handleKeypress

    @el.append(@header.render().el)
    @el.append(@searchBar.render().el)
    @el.append(@searchResultsList.render().el)
    @el.append(@currentAlbumsList.render().el)
    @el.append(@archivedAlbumsList.render().el)

    @currentAlbumsList.populate()
    @archivedAlbumsList.populate()
    @switchList("currentAlbumsList")
    @searchBar.focus()

  navigate: (href) ->
    switch href
      when "/current"
        @switchList("currentAlbumsList")
      when "/archived"
        @switchList("archivedAlbumsList")

  handleKeypress: (e) ->
    switch e.keyCode
      when 38
        e.preventDefault()
        @tab(-1)
      when 40
        e.preventDefault()
        @tab(+1)

  tab: (offset) ->
    focus = $(':focus')[0]

    if focus?
      indices        = $("[tabindex]").get().map (e) -> e.tabIndex
      nextIndexIndex = (_.indexOf(indices, focus.tabIndex) + offset + indices.length) % indices.length
      nextIndex      = indices[nextIndexIndex]

      $("[tabindex=#{nextIndex}]").focus()

  startSearch: (query) ->
    @searchBar.showSpinner()
    AlbumSearchResults.url = "/albums/search?" + $.param({q: query})
    AlbumSearchResults.fetch()

  finishSearch: ->
    @searchBar.hideSpinner()
    @switchList("searchResultsList")

  addAlbum: (album) ->
    album.set({"added": new Date().getTime()})
    CurrentAlbums.add(album)
    album.collection = CurrentAlbums
    album.save()

    @switchList("currentAlbumsList")
    @searchBar.clear().focus()
    @header.switchTo("nav")

  switchList: (listName) ->
    @lists.forEach (l) -> l.hide()
    @currentList = this[listName]
    @currentList.show()
    @setTabIndex(0)

_.extend AppView.prototype, Tabbable, {
  getTabbableElements: ->
    @searchBar.getTabbableElements()
      .concat(@currentList.getTabbableElements())
}

window.App = new AppView
