class Views.FriendBrowser extends Views.View
  className: 'friend-browser'

  initialize: ->
    _.bindAll(this, "loadFriends", "loadFriendsAlbums")

    @spinner = $('<div class="spinner"/>')

    @friendList = new UI.FriendList({collection: Friends})
    @friendList.bind "select", @loadFriendsAlbums

    @albumList = new UI.FriendsAlbumsList({collection: FriendsAlbums})

    @views = [@spinner, @friendList, @albumList]

    @bind "show", @loadFriends

    Friends.bind       "refresh", => @switchView("friendList")
    FriendsAlbums.bind "refresh", => @switchView("albumList")
    @albumList.bind    "back",    => @switchView("friendList")

  render: ->
    $(@el).append(@spinner)
    $(@el).append(@friendList.render().el)
    $(@el).append(@albumList.render().el)
    this

  handleKeypress: (e) -> true

  loadFriends: ->
    if UserInfo and Friends.length == 0
      @switchView("spinner")
      Friends.url = "/friends?auth_token=#{UserInfo.auth_token}"
      Friends.fetch()
    else
      @switchView("friendList")

  loadFriendsAlbums: (user) ->
    @albumList.user = user
    FriendsAlbums.url = user.albumsUrl()
    FriendsAlbums.fetch()

_.extend Views.FriendBrowser.prototype, Views.Tabbable,
  getTabbableElements: -> [@currentView]

class Touch.FriendBrowser extends Views.FriendBrowser
  switchView: (viewName) ->
    @views.forEach (v) -> $(v.el).children().removeClass('touched')
    super(viewName)

  
