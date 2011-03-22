class Header extends Backbone.View
  className: 'header'

  template: _.template('
    <div class="intro">What are you listening to?</div>
    <div class="sign-in"><a href="/auth/twitter">Sign in with Twitter</a> to save your list.</div>
  ')

  initialize: (options) ->
    @section = options.section if options? and options.section?

  render: ->
    $(@el).html(@template()).css({ position: "relative", overflow: "hidden" })
    $(@el).children().css({ position: "absolute", top: "0" }).hide()
    $(@el).children(".#{@section}").show()
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

