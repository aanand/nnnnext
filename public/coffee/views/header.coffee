class Header extends Backbone.View
  className: 'header'

  template: _.template('
    <div class="sections">
      <div class="intro">What are you listening to?</div>
      <ul class="nav">
        <li class="current"><a href="/current">Current</a></li>
        <li class="archived"><a href="/archived">Archived</a></li>
      </ul>
    </div>

    <div class="sync-controls">
      <div class="button"/>
      <div class="spinner" style="display: none"/>
    </div>
  ')

  events:
    "click .nav a": "navClick"
    "click .sync-controls .button": "syncClick"

  render: ->
    $(@el)
      .html(@template())
      .css({ position: "relative", overflow: "hidden" })
      .find(".sections > *")
        .css({ position: "absolute", top: "0", left: "0", right: "0" })
        .not(".#{@section}")
          .hide()

    @navigate(@href) if @href?

    this

  navClick: (e) ->
    e.preventDefault()
    href = $(e.target).attr("href")
    @navigate(href)
    @trigger("navigate", href)
  
  syncClick: (e) ->
    @trigger("syncButtonClick")

  navigate: (href) ->
    @href = href
    @$('.nav a')
      .removeClass('current')
      .filter("[href='#{@href}']")
        .addClass('current')

  switchTo: (newSection) ->
    return if newSection == @section

    height   = $(@el).height()
    sections = @$(".sections").children()

    sections.filter(".#{@section}")
      .animate({top: -height})

    sections.filter(".#{newSection}")
      .css({top: height})
      .show()
      .animate({top: 0})

    @section = newSection

  syncing: (inProgress) ->
    if inProgress
      @$(".sync-controls .button").hide()
      @$(".sync-controls .spinner").show()
    else
      @$(".sync-controls .button").show()
      @$(".sync-controls .spinner").hide()

