class Header extends Backbone.View
  className: 'header'

  template: _.template('
    <div class="intro">What are you listening to?</div>
    <ul class="nav">
      <li class="current"><a href="/current">Current</a></li>
      <li class="archived"><a href="/archived">Archived</a></li>
    </ul>
  ')

  events:
    "click .nav a": "navClick"

  render: ->
    $(@el)
      .html(@template())
      .css({ position: "relative", overflow: "hidden" })
      .children()
        .css({ position: "absolute", top: "0" })
        .not(".#{@section}")
          .hide()

    @navigate(@href) if @href?

    this

  navClick: (e) ->
    e.preventDefault()
    href = $(e.target).attr("href")
    @navigate(href)
    @trigger("navigate", href)

  navigate: (href) ->
    @href = href
    @$('.nav a')
      .removeClass('current')
      .filter("[href='#{@href}']")
        .addClass('current')

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

