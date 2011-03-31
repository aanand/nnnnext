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

    @banner = new Banner

    @header = new Header
    @header.href = "/current"

    if SavedAlbums.length > 0
      @header.section = "nav"
    else
      @header.section = "intro"

    @searchBar          = new AlbumSearchBar({collection: AlbumSearchResults})
    @searchResultsList  = new AlbumSearchList({collection: AlbumSearchResults})
    @savedAlbumsList    = new SavedAlbumsList({collection: SavedAlbums})

    @lists = [@searchResultsList, @savedAlbumsList]

    _.bindAll(this, "navigate", "addAlbum", "startSearch", "finishSearch", "cancelSearch", "startSync", "startSyncOrSignIn", "finishSync", "handleKeypress")

    @header.bind            "navigate", @navigate
    @header.bind            "syncButtonClick", @startSyncOrSignIn
    @searchBar.bind         "submit",  @startSearch
    @searchBar.bind         "clear", @cancelSearch
    @searchResultsList.bind "select",  @addAlbum
    AlbumSearchResults.bind "refresh", @finishSearch
    SavedAlbums.bind        "modelSaved", @startSync
    Sync.bind               "finish",  @finishSync
    $(window).bind          "keydown", @handleKeypress

    @el.append(@banner.render().el)
    @el.append(@header.render().el)
    @el.append(@searchBar.render().el)
    @el.append(@searchResultsList.render().el)
    @el.append(@savedAlbumsList.render().el)

    @savedAlbumsList.populate()
    @savedAlbumsList.filter("current")
    @switchList("savedAlbumsList")
    @searchBar.focus()

    @startSync()

  startSync: ->
    return unless UserInfo?
    @header.syncing(true)
    Sync.start(SavedAlbums, "/albums/sync")

  startSyncOrSignIn: ->
    if UserInfo?
      @startSync()
    else
      if window.confirm("Sign in with Twitter to start saving your list?")
        window.location.href = "/auth/twitter"

  finishSync: ->
    window.setTimeout((=> @header.syncing(false)), 500)
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
      else
        @searchBar.handleKeypress(e)

  tab: (offset) ->
    focus = $(':focus')[0]

    if focus?
      indices        = $("[tabindex]").get().map (e) -> e.tabIndex
      nextIndexIndex = (_.indexOf(indices, focus.tabIndex) + offset + indices.length) % indices.length
      nextIndex      = indices[nextIndexIndex]

      $("[tabindex=#{nextIndex}]").focus()

  startSearch: (query) ->
    return unless query
    @searchBar.showSpinner()
    AlbumSearchResults.url = "/albums/search?" + $.param({q: query})
    AlbumSearchResults.fetch()

  finishSearch: ->
    @searchBar.hideSpinner()
    @searchResultsList.populate()
    @switchList("searchResultsList")

  cancelSearch: ->
    @switchList("savedAlbumsList")

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
