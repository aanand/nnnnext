class Views.Links extends Views.View
  template: _.template('
    <div class="about">
      <a href="/about">About</a>
    </div>

    <% if (signedIn) { %>
      <div class="signout">
        <a href="/signout">Sign out</a>
      </div>
    <% } else { %>
      <div class="signin">
        <a href="/auth/twitter">Sign in</a>
      </div>
    <% } %>
  ')

  render: ->
    $(@el).html(@template({signedIn: UserInfo?}))

    @$('.about a').click (e) =>
      e.preventDefault()
      @trigger("aboutClick")

    this

class Touch.Links extends Views.Links
  render: ->
    super()
    @$('.signin a, .signout a').sitDownMan()
    this

