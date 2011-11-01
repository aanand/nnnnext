class Views.ListManager extends Views.View
  initialize: ->
    _.bindAll(this, "addAlbum", "startSearch", "finishSearch", "cancelSearch")

    @albumSearchResults = new AlbumCollection

    @searchBar          = new UI.AlbumSearchBar({collection: @albumSearchResults, listManager: this})
    @searchResultsList  = new UI.AlbumSearchList({collection: @albumSearchResults})
    @currentAlbumsList  = new UI.SavedAlbumsList({collection: CurrentAlbums})
    @archivedAlbumsList = new UI.SavedAlbumsList({collection: ArchivedAlbums})
    
    @views = [@searchResultsList, @currentAlbumsList, @archivedAlbumsList]

    @searchBar.bind         "submit",  @startSearch
    @searchBar.bind         "clear", @cancelSearch
    @searchResultsList.bind "select",  @addAlbum
    @albumSearchResults.bind "refresh", @finishSearch

    for coll in [SavedAlbums, @albumSearchResults]
      for event in ["add", "remove", "refresh"]
        coll.bind event, => @trigger("update")

    @bind "show", => @searchBar.focus()

  isSearching: -> @currentView == @searchResultsList

  render: ->
    for v in [@searchBar, @searchResultsList, @currentAlbumsList, @archivedAlbumsList]
      $(@el).append(v.el)
      v.render()

    @currentAlbumsList.populate()
    @archivedAlbumsList.populate()

    this

  setHint: (hint) ->
    @currentAlbumsList.setHint(hint)

  handleKeypress: (e) ->
    @searchBar.handleKeypress(e)

  switchView: (name) ->
    switch name
      when "current", "archived"
        super("#{name}AlbumsList")
      else
        super(name)

  focusSearchBar: ->
    @searchBar.focus()

  startSearch: (query) ->
    return unless query
    @searchBar.showSpinner()
    @albumSearchResults.url = "/albums/search?" + $.param({q: query})
    @albumSearchResults.fetch()

  finishSearch: ->
    @searchBar.hideSpinner()
    @searchResultsList.populate()
    @switchView("searchResultsList")

  cancelSearch: ->
    @switchView("current")

  addAlbum: (album) ->
    album.addTo(SavedAlbums)

    @switchView("current")
    @searchBar.cancel()
    @trigger("addAlbum")

_.extend Views.ListManager.prototype, Views.Tabbable,
  getTabbableElements: -> [@searchBar, @currentView]

class Desktop.ListManager extends Views.ListManager
  addAlbum: (album) ->
    super(album)
    @focusSearchBar()

class Touch.ListManager extends Views.ListManager
  finishSearch: ->
    super()
    console.log "blurring search bar"
    @searchBar.blur()

