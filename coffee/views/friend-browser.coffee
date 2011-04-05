Friends = new UserCollection
Friends.url = "/friends"

FriendsAlbums = new AlbumCollection

class FriendBrowser extends View
  initialize: ->
    _.bindAll(this, "loadFriendsAlbums")

    @friendList = new FriendList({collection: Friends})
    @friendList.bind "select", @loadFriendsAlbums

    @albumList = new FriendsAlbumsList({collection: FriendsAlbums})

    @views = [@friendList, @albumList]

    FriendsAlbums.bind "refresh", => @switchView("albumList")

    @bind "show", =>
      @switchView("friendList")
      @friendList.fetch()

    @albumList.bind "back", => @switchView("friendList")

  render: ->
    $(@el).append(@friendList.render().el)
    $(@el).append(@albumList.render().el)
    this

  handleKeypress: (e) -> true

  loadFriendsAlbums: (user) ->
    @albumList.user = user
    FriendsAlbums.url = user.albumsUrl()
    FriendsAlbums.fetch()

_.extend FriendBrowser.prototype, Tabbable,
  getTabbableElements: -> [@currentView]

