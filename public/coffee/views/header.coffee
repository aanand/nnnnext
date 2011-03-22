class Header extends Backbone.View
  className: 'header'

  template: _.template('
    <div class="intro">What are you listening to?</div>
    <div class="sign-in"><a href="/auth/twitter">Sign in with Twitter</a> to save and share your list.</div>
    <ul class="nav">
      <li class="username"/>
    </ul>
  ')

  render: ->
    $(@el)
      .html(@template())
      .css({ position: "relative", overflow: "hidden" })
      .children()
        .css({ position: "absolute", top: "0" })
        .not(".#{@section}")
          .hide()

    if UserInfo?
      @$(".username").text("@#{UserInfo.nickname}")

    this

  switchTo: (newSection) ->
    return if newSection == @section

    height   = $(@el).height()
    sections = $(@el).children()

    sections.filter(".#{@section}")
      .animate({top: -height})

    sections.filter(".#{newSection}")
      .css({top: height})
      .show()
      .animate({top: 0})

    @section = newSection

