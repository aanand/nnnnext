class FriendList extends View
  tagName: 'ul'
  className: 'friend-list'

  initialize: ->
    @collection.bind "refresh", => @populate()

  populate: ->
    $(@el).empty()

    @collection.models.forEach (user) =>
      view = new FriendView({model: user, list: this})
      user.view = view
      $(@el).append(view.render().el)

    @reTab()

_.extend FriendList.prototype, Tabbable,
  getTabbableElements: -> @collection.models.map (m) -> m.view.el
