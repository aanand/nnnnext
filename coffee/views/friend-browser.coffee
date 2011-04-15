Friends = new UserCollection
Friends.url = "/friends"

FriendsAlbums = new AlbumCollection

class Views.FriendBrowser extends Views.View
  className: 'friend-browser'

  initialize: ->
    _.bindAll(this, "loadFriends", "loadFriendsAlbums")

    @signInMessage = $('
      <div class="not-signed-in">
        <a href="/auth/twitter">Connect with Twitter</a>
        to share your list with your friends.
      </div>
    ')

    @spinner = $('<div class="spinner"/>')

    @friendList = new UI.FriendList({collection: Friends})
    @friendList.bind "select", @loadFriendsAlbums

    @albumList = new UI.FriendsAlbumsList({collection: FriendsAlbums})

    @views = [@signInMessage, @spinner, @friendList, @albumList]

    @bind "show", @loadFriends

    Friends.bind       "refresh", => @switchView("friendList")
    FriendsAlbums.bind "refresh", => @switchView("albumList")
    @albumList.bind    "back",    => @switchView("friendList")

  render: ->
    $(@el).append(@signInMessage)
    $(@el).append(@spinner)
    $(@el).append(@friendList.render().el)
    $(@el).append(@albumList.render().el)
    this

  handleKeypress: (e) -> true

  loadFriends: ->
    if UserInfo?
      if Friends.length > 0
        @switchView("friendList")
      else
        @switchView("spinner")
        Friends.fetch()
    else
      @switchView("signInMessage")

  loadFriendsAlbums: (user) ->
    @albumList.user = user
    FriendsAlbums.url = user.albumsUrl()
    FriendsAlbums.fetch()

_.extend Views.FriendBrowser.prototype, Views.Tabbable,
  getTabbableElements: -> [@currentView]

