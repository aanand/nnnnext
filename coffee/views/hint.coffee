class Views.Hint extends Views.View
  className: 'hint'

  initialize: (options) ->
    options = options ? {}
    @dismissButton = options.dismissButton ? true

  events:
    "click .dismiss": "dismiss"

  render: ->
    $(@el)
      .empty()
      .append($("<div class='text'/>").html(@getMessage()))

    $(@el).append("<div class='dismiss'/>") if @dismissButton

    this

  remove: ->
    $(@el).remove()

  dismiss: ->
    $(@el).fadeOut 'fast', =>
      @remove()
      window.Hint.dismiss(this)

class Views.IntroHint extends Views.Hint
  getMessage: -> "
    <p><strong>nnnnext</strong> is a todo list for your music.</p>
    <p>Use the search bar to find albums you're listening to (or want to listen to) and add them to your list.</p>
  "

class Views.FirstAlbumHint extends Views.Hint
  getMessage: -> "
    <p>Hover over an album in your list to rate it, check it off or delete it.</p>
  "

class Touch.FirstAlbumHint extends Views.FirstAlbumHint
  getMessage: -> "
    <p>Tap an album in your list to rate it, check it off or delete it.</p>
  "

class Views.SignInHint extends Views.Hint
  getMessage: -> "
    <p>If you <a href='/auth/twitter'>connect with Twitter</a>, you can:</p>
    
    <ul>
      <li>sync your list across multiple browsers and devices</li>
      <li>share it with your friends</li>
      <li>see what they're listening to</li>
    </ul>

    <p><strong>nnnnext</strong> will never tweet anything on your behalf.</p>
  "

class Touch.SignInHint extends Views.SignInHint
  render: ->
    super()
    @$('a').sitDownMan()
    this
