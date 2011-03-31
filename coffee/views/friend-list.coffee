class FriendList extends Backbone.View
  className: 'friend-list'

  template: _.template('
    <div class="signed-in" style="display:none">
      Coming soon!
    </div>

    <div class="not-signed-in">
      <a href="/auth/twitter">Connect with Twitter</a>
      to share your list with your friends.
    </div>
  ')

  render: ->
    $(@el).html(@template())
    
    if UserInfo?
      @$(".signed-in").show()
      @$(".not-signed-in").hide()

    this

