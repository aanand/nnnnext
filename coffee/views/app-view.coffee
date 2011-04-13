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
    
    scroller = $("<div id='scroller'/>")
    @views.forEach (v) -> scroller.append(v.render().el)
    @scrollWrapper = $("<div id='scroll-wrapper'/>").append(scroller).appendTo(@el)

    @iScroll = new iScroll(@scrollWrapper.get(0)) if Mobile

    @navigation.hide() if SavedAlbums.length == 0 and not(UserInfo?)
    @tabIndex = 0
    @navigate(@navigation.href)

    @startSync()

  refreshScroll: ->
    return unless @iScroll?
    window.setTimeout((=> @iScroll.refresh()), 0)
    console.log @iScroll.y

  switchView: (viewName) ->
    super(viewName)
    @refreshScroll()

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

