class AppView extends View
  el: $('#app')

  initialize: ->
    SavedAlbums.fetch()

    @banner = new Banner

    @header = new Header

    @navigation = new Navigation
    @navigation.href = "/current"
    @header.addNavigation(@navigation) unless Mobile

    @listManager   = new ListManager
    @friendBrowser = new FriendBrowser

    @views = [@listManager, @friendBrowser]

    _.bindAll(this, "navigate", "startSync", "finishSync", "handleKeypress")

    @navigation.bind  "navigate",        @navigate
    @header.bind      "syncButtonClick", @startSync
    @listManager.bind "addAlbum",        => @navigation.show()
    SavedAlbums.bind  "modelSaved",      @startSync
    Sync.bind         "finish",          @finishSync
    $(window).bind    "keydown",         @handleKeypress

    @el.append(@banner.render().el)
    @el.append(@header.render().el)
    @el.append(@navigation.render().el) if Mobile
    @el.append(@listManager.render().el)
    @el.append(@friendBrowser.render().el)

    @navigation.hide() if SavedAlbums.length == 0 and not(UserInfo?)
    @tabIndex = 0
    @navigate(@navigation.href)

    @startSync()

  startSync: ->
    return unless UserInfo?
    @header.syncing(true)
    Sync.start(SavedAlbums, "/albums/sync")

  finishSync: ->
    window.setTimeout((=> @header.syncing(false)), 500)
    @navigation.show() if SavedAlbums.length > 0

  navigate: (href) ->
    switch href
      when "/current"
        @listManager.switchView("current")
        @switchView("listManager")
      when "/archived"
        @listManager.switchView("archived")
        @switchView("listManager")
      when "/friends"
        @switchView("friendBrowser")

  handleKeypress: (e) ->
    switch e.keyCode
      when 38
        e.preventDefault()
        @tab(-1)
      when 40
        e.preventDefault()
        @tab(+1)
      else
        @currentView.handleKeypress(e)

  tab: (offset) ->
    elements  = _.sortBy $(":visible[tabindex]").get(), (e) -> e.tabIndex
    focus     = $(':focus').filter(":visible")[0]
    nextIndex = null

    if focus?
      currentIndex = _.indexOf elements.map((e) -> e.tabIndex), focus.tabIndex
      nextIndex    = (currentIndex + offset + elements.length) % elements.length
    else
      nextIndex = 0

    $(focus).blur() if focus?
    $(elements[nextIndex]).focus()

_.extend AppView.prototype, Tabbable, {
  getTabbableElements: -> [@currentView]
}

