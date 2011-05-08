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
    this

class Touch.Banner extends Views.Banner
  render: ->
    super()

    @$('.signin a').sitDownMan()

    @$('.signout a').click (e) ->
      e.preventDefault()

      if confirm("Are you sure you want to sign out?")
        window.location = this.href

    this
