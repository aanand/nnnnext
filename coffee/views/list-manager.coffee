class Views.ListManager extends Views.View
  initialize: ->
    _.bindAll(this, "addAlbum", "startSearch", "finishSearch", "cancelSearch")

    @albumSearchResults = new AlbumCollection

    @searchBar          = new UI.AlbumSearchBar({collection: @albumSearchResults})
    @searchResultsList  = new UI.AlbumSearchList({collection: @albumSearchResults})
    @currentAlbumsList  = new UI.SavedAlbumsList({collection: CurrentAlbums})
    @archivedAlbumsList = new UI.SavedAlbumsList({collection: ArchivedAlbums})
    
    @views = [@searchResultsList, @currentAlbumsList, @archivedAlbumsList]

    @searchBar.bind         "submit",  @startSearch
    @searchBar.bind         "clear", @cancelSearch
    @searchResultsList.bind "select",  @addAlbum
    @albumSearchResults.bind "refresh", @finishSearch

    @bind "show", => @searchBar.focus()

  render: ->
    $(@el).append(@searchBar.render().el)
    $(@el).append(@searchResultsList.render().el)
    $(@el).append(@currentAlbumsList.render().el)
    $(@el).append(@archivedAlbumsList.render().el)
    
    @currentAlbumsList.populate()
    @archivedAlbumsList.populate()

    this

  handleKeypress: (e) ->
    @searchBar.handleKeypress(e)

  switchView: (name) ->
    switch name
      when "current", "archived"
        super("#{name}AlbumsList")
      else
        super(name)

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
    @searchBar.clear()
    @trigger("addAlbum")

_.extend Views.ListManager.prototype, Views.Tabbable,
  getTabbableElements: -> [@searchBar, @currentView]

class Desktop.ListManager extends Views.ListManager
  addAlbum: (album) ->
    super(album)
    console.log "focusing search bar"
    @searchBar.focus()

class Touch.ListManager extends Views.ListManager
  finishSearch: ->
    super()
    console.log "blurring search bar"
    @searchBar.blur()

