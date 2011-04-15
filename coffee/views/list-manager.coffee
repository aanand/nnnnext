class Views.ListManager extends Views.View
  initialize: ->
    _.bindAll(this, "addAlbum", "startSearch", "finishSearch", "cancelSearch")

    @albumSearchResults = new AlbumCollection

    @searchBar          = new UI.AlbumSearchBar({collection: @albumSearchResults})
    @searchResultsList  = new UI.AlbumSearchList({collection: @albumSearchResults})
    @savedAlbumsList    = new UI.SavedAlbumsList({collection: SavedAlbums})
    
    @views = [@searchResultsList, @savedAlbumsList]

    @searchBar.bind         "submit",  @startSearch
    @searchBar.bind         "clear", @cancelSearch
    @searchResultsList.bind "select",  @addAlbum
    @albumSearchResults.bind "refresh", @finishSearch

    @bind "show", => @searchBar.focus()

  render: ->
    $(@el).append(@searchBar.render().el)
    $(@el).append(@searchResultsList.render().el)
    $(@el).append(@savedAlbumsList.render().el)
    
    @savedAlbumsList.populate()

    this

  handleKeypress: (e) ->
    @searchBar.handleKeypress(e)

  switchView: (name) ->
    switch name
      when "current", "archived"
        super("savedAlbumsList")
        @savedAlbumsList.filter(name)
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
    @switchView("savedAlbumsList")

  addAlbum: (album) ->
    album.addTo(SavedAlbums)

    @switchView("savedAlbumsList")
    @searchBar.clear()
    @trigger("addAlbum")

_.extend Views.ListManager.prototype, Tabbable,
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

