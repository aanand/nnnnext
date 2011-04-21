class Views.FriendList extends Views.List
  className: 'friend-list'

  initialize: (options) ->
    super(options)
    @collection.bind "refresh", @populate

  makeView: (user) ->
    user.view = new UI.FriendView({model: user, list: this})

  render: ->
    super()

    unless UserInfo?
      hint = new UI.SignInHint({dismissButton: false})
      @appendHint(hint)

    this

