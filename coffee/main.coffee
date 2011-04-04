storageNamespacePrefix   = "nnnnext"
unsyncedStorageNamespace = "#{storageNamespacePrefix}/unsynced"
storageNamespace         = null

if UserInfo?
  storageNamespace = "#{storageNamespacePrefix}/#{UserInfo._id}"

  # Copy unsynced albums into user namespace
  _.keys(localStorage).forEach (key) ->
    if key.search("#{unsyncedStorageNamespace}/") == 0
      value  = localStorage.getItem(key)
      newKey = key.replace(unsyncedStorageNamespace, storageNamespace)

      localStorage.setItem(newKey, value)
      localStorage.removeItem(key)

else
  storageNamespace = unsyncedStorageNamespace

SavedAlbums = new AlbumCollection {
  localStorage: new Store("#{storageNamespace}/albums")
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
    @friendList         = new FriendList

    @views = [@searchResultsList, @savedAlbumsList, @friendList]

    _.bindAll(this, "navigate", "addAlbum", "startSearch", "finishSearch", "cancelSearch", "startSync", "finishSync", "handleKeypress")

    @header.bind            "navigate", @navigate
    @header.bind            "syncButtonClick", @startSync
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
    @el.append(@friendList.render().el)

    @savedAlbumsList.populate()
    @savedAlbumsList.filter("current")
    @switchView("savedAlbumsList")
    @searchBar.focus()

    @startSync()

  startSync: ->
    return unless UserInfo?
    @header.syncing(true)
    Sync.start(SavedAlbums, "/albums/sync")

  finishSync: ->
    window.setTimeout((=> @header.syncing(false)), 500)
    @header.switchTo("nav") if SavedAlbums.length > 0

  navigate: (href) ->
    switch href
      when "/current"
        @switchView("savedAlbumsList")
        @savedAlbumsList.filter("current")
      when "/archived"
        @switchView("savedAlbumsList")
        @savedAlbumsList.filter("archived")
      when "/friends"
        @switchView("friendList")

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
      indices        = $(":visible[tabindex]").get().map (e) -> e.tabIndex
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
    @switchView("searchResultsList")

  cancelSearch: ->
    @switchView("savedAlbumsList")

  addAlbum: (album) ->
    album.addTo(SavedAlbums)

    @switchView("savedAlbumsList")
    @searchBar.clear().focus()
    @header.switchTo("nav")

  switchView: (listName) ->
    @views.forEach (l) -> l.hide()
    @currentView = this[listName]
    @currentView.show()
    @setTabIndex(0)

_.extend AppView.prototype, Tabbable, {
  getTabbableElements: ->
    @searchBar.getTabbableElements()
      .concat(@currentView.getTabbableElements())
}

App = new AppView
