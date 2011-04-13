class Navigation extends View
  className: 'navigation'

  template: _.template('
    <div class="inner">
      <a class="current" href="/current">Current</a>
      <a class="archived" href="/archived">Archived</a>
      <a class="friends" href="/friends">Friends</a>
    </div>
  ')

  events:
    "click a": "handleClick"
    
  render: ->
    $(@el).html(@template())
    @navigate(@href) if @href?
    this

  handleClick: (e) ->
    e.preventDefault()
    href = $(e.target).attr("href")
    @navigate(href)
    @trigger("navigate", href)

  navigate: (href) ->
    @href = href
    @$('a')
      .removeClass('active')
      .filter("[href='#{@href}']")
        .addClass('active')

  show: ->
    if Mobile
      $(@el).css({ display: "table" })
    else
      super()

  # show: ->
    # $(@el).css({ position: "relative", overflow: "hidden" })

    # height = $(@el).height()

    # @$('.title')
      # .css({ position: "absolute", top: "0", left: "0", right: "0" })
      # .show()
      # .animate({ top: -height })

    # @$('.nav')
      # .css({ position: "absolute", top: height, left: "0", right: "0" })
      # .show()
      # .animate({ top: 0 })

