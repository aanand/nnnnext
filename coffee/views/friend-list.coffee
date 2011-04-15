class Views.FriendList extends Views.View
  tagName: 'ul'
  className: 'friend-list'

  initialize: ->
    @collection.bind "refresh", => @populate()

  populate: ->
    $(@el).empty()

    @collection.models.forEach (user) =>
      view = new UI.FriendView({model: user, list: this})
      user.view = view
      $(@el).append(view.render().el)

    @reTab()

_.extend Views.FriendList.prototype, Views.Tabbable,
  getTabbableElements: -> @collection.models.map (m) -> m.view.el
