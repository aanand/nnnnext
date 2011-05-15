class Views.Links extends Views.View
  template: _.template('
    <div class="about">
      <a href="/about">About</a>
    </div>

    <% if (signedIn) { %>
      <div class="signout">
        <a>Sign out</a>
      </div>
    <% } else { %>
      <div class="signin">
        <a href="/auth/twitter">Sign in</a>
      </div>
    <% } %>
  ')

  render: ->
    $(@el).html(@template({signedIn: UserInfo}))

    @$('.about a').click (e) =>
      e.preventDefault()
      @trigger("aboutClick")

    @$('.signout a').click (e) =>
      e.preventDefault()
      @trigger("signoutClick")

    this

class Touch.Links extends Views.Links
  render: ->
    super()
    @$('.signin a').sitDownMan()
    this

