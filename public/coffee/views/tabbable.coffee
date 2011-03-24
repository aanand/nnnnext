Tabbable =
  setTabIndex: (n) ->
    @getTabbableElements().forEach (e) ->
      if typeof e.setTabIndex == 'function'
        n = e.setTabIndex(n)
      else
        e.tabIndex = n
        n++

      n

  getTabbableElements: ->
    [@el]

