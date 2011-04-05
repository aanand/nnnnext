Tabbable =
  setTabIndex: (n) ->
    @tabIndex = n

    @getTabbableElements().forEach (e) ->
      if typeof e.setTabIndex == 'function'
        n = e.setTabIndex(n)
      else
        e.tabIndex = n
        n++

    n

  reTab: ->
    @setTabIndex(@tabIndex) if @tabIndex?

  getTabbableElements: ->
    [@el]

