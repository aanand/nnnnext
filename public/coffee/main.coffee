SavedAlbums = new AlbumCollection {
  localStorage: new Store("albums")
  sync:         Backbone.localSync
  comparator:   (a) -> -a.get("stateChanged")
}

AlbumSearchResults = new AlbumCollection

class AppView extends Backbone.View
  el: $('#app')

  initialize: ->
    SavedAlbums.fetch()

    @header = new Header
    @header.href = "/current"

    if SavedAlbums.length > 0
      @header.section = "nav"
    else
      @header.section = "intro"

    @searchBar          = new AlbumSearchBar({collection: AlbumSearchResults})
    @searchResultsList  = new AlbumSearchList({collection: AlbumSearchResults})
    @savedAlbumsList    = new SavedAlbumsList({collection: SavedAlbums})
    @syncingMessage     = new SyncingMessage

    @lists = [@searchResultsList, @savedAlbumsList]

    _.bindAll(this, "navigate", "addAlbum", "startSearch", "finishSearch", "startSync", "finishSync", "handleKeypress")

    @header.bind            "navigate", @navigate
    @searchBar.bind         "submit",  @startSearch
    @searchResultsList.bind "select",  @addAlbum
    AlbumSearchResults.bind "refresh", @finishSearch
    Sync.bind               "finish",  @finishSync
    $(window).bind          "keydown", @handleKeypress

    @el.append(@header.render().el)
    @el.append(@searchBar.render().el)
    @el.append(@searchResultsList.render().el)
    @el.append(@savedAlbumsList.render().el)
    @el.append(@syncingMessage.render().el)

    @savedAlbumsList.populate()
    @savedAlbumsList.filter("current")
    @switchList("savedAlbumsList")
    @searchBar.focus()

    @startSync() if UserInfo?

  startSync: ->
    @syncingMessage.show()
    Sync.start(SavedAlbums, "/albums/sync")

  finishSync: ->
    @syncingMessage.hide()
    @header.switchTo("nav") if SavedAlbums.length > 0

  navigate: (href) ->
    switch href
      when "/current"
        @savedAlbumsList.filter("current")
      when "/archived"
        @savedAlbumsList.filter("archived")

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
    @searchResultsList.populate()
    @switchList("searchResultsList")

  addAlbum: (album) ->
    album.addTo(SavedAlbums)

    @switchList("savedAlbumsList")
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

App = new AppView
