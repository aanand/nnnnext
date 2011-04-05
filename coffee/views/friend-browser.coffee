Friends = new UserCollection
Friends.url = "/friends"

FriendsAlbums = new AlbumCollection

class FriendBrowser extends View
  initialize: ->
    _.bindAll(this, "switchToFriend")

    @friendList = new FriendList({collection: Friends})
    @friendList.bind "select", @switchToFriend

    @albumList = new FriendsAlbumsList({collection: FriendsAlbums})

    @views = [@friendList, @albumList]

    FriendsAlbums.bind "refresh", => @switchView("albumList")

    @bind "show", =>
      @switchView("friendList")
      @friendList.fetch()

  render: ->
    $(@el).append(@friendList.render().el)
    $(@el).append(@albumList.render().el)
    this

  handleKeypress: (e) -> true

  switchToFriend: (user) ->
    FriendsAlbums.url = user.albumsUrl()
    FriendsAlbums.fetch()

_.extend FriendBrowser.prototype, Tabbable,
  getTabbableElements: -> [@currentView]

