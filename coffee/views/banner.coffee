class Views.Banner extends Views.View
  className: 'banner'

  template: _.template('
    <div class="title"/>

    <% if (signedIn) { %>
      <div class="signout">
        <a href="/signout"/>
      </div>
    <% } else { %>
      <div class="signin">
        <a href="/auth/twitter"/>
      </div>
    <% } %>
  ')

  render: ->
    $(@el).html(@template({signedIn: UserInfo?}))

    @$('.signout a').click (e) ->
      e.preventDefault()

      $.get this.href, ->
        if confirm("OK, you're signed out of nnnnext. Sign out of Twitter too?")
          window.location.href = "http://twitter.com/logout"
        else
          window.location.reload()

    this

class Touch.Banner extends Views.Banner
  render: ->
    super()

    @$('.signin a').click (e) ->
      e.preventDefault()
      window.location = this.href

    this
