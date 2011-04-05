class FriendList extends View
  tagName: 'ul'
  className: 'friend-list'

  initialize: ->
    @collection.bind "refresh", => @populate()

  fetch: ->
    if UserInfo?
      @collection.fetch() unless @collection.length > 0
    else
      $(@el).html('
        <li class="not-signed-in">
          <a href="/auth/twitter">Connect with Twitter</a>
          to share your list with your friends.
        </li>
      ')

  populate: ->
    $(@el).empty()

    @collection.models.forEach (user) =>
      view = new FriendView({model: user, list: this})
      user.view = view
      $(@el).append(view.render().el)

    @reTab()

_.extend FriendList.prototype, Tabbable,
  getTabbableElements: -> @collection.models.map (m) -> m.view.el
