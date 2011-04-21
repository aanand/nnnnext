class Views.AppView extends Views.View
  el: $('#app')

  initialize: ->
    SavedAlbums.fetch()

    @banner = new UI.Banner

    @header = new UI.Header

    @initNavigation()

    @listManager   = new UI.ListManager
    @friendBrowser = new UI.FriendBrowser

    @views = [@listManager, @friendBrowser]

    _.bindAll(this, "navigate", "startSync", "finishSync", "handleKeypress", "setHint")

    @navigation.bind  "navigate",        @navigate
    @header.bind      "syncButtonClick", @startSync
    @listManager.bind "addAlbum",        => @navigation.show()
    LocalSync.bind    "sync",            @startSync
    Sync.bind         "finish",          @finishSync
    CurrentAlbums.bind "add",            @setHint
    CurrentAlbums.bind "remove",         @setHint
    $(window).bind    "keydown",         @handleKeypress

    @renderSubviews()

    @navigation.hide() if @isNewUser()

    @tabIndex = 0
    @navigate(@navigation.href)

    @startSync()

  initNavigation: ->
    @navigation = new UI.Navigation
    @navigation.href = "/current"

  renderSubviews: ->
    @el.append(@banner.render().el)
    @el.append(@header.render().el)

  refreshScroll: ->

  appendTo: (parent) ->
    $(parent).append(@render().el)
    @setHint()

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

    @setHint()

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

  setHint: ->
    hintClass = if UserInfo?
      null
    else if @isNewUser()
      hintClass = 'IntroHint'
    else if @hasOneAlbum()
      hintClass = 'FirstAlbumHint'
    else
      hintClass = 'SignInHint'

    hint = if hintClass?
      if Hint.isDismissed(hintClass)
        null
      else
        new UI[hintClass]

    @listManager.setHint(hint)

  isNewUser: ->
    SavedAlbums.length == 0 and not(UserInfo?)

  hasOneAlbum: ->
    SavedAlbums.length == 1 and SavedAlbums.models[0].get("state") == "current"

_.extend Views.AppView.prototype, Views.Tabbable, {
  getTabbableElements: -> [@currentView]
}

class Desktop.AppView extends Views.AppView
  initNavigation: ->
    super()
    console.log "adding navigation to header"
    @header.addNavigation(@navigation)

  renderSubviews: ->
    super()
    console.log "appending subviews directly to @el"
    @views.forEach (v) => @el.append(v.render().el)

  appendTo: (parent) ->
    super(parent)
    @listManager.focusSearchBar()

class Touch.AppView extends Views.AppView
  renderSubviews: ->
    super()
    console.log "appending navigation directly to @el"
    @el.append(@navigation.render().el)

    console.log "appending subviews to #scroller"
    scroller = $("<div id='scroller'/>")
    @views.forEach (v) -> scroller.append(v.render().el)
    @scrollWrapper = $("<div id='scroll-wrapper'/>").append(scroller).appendTo(@el)

    @iScroll = new iScroll(@scrollWrapper.get(0))

  appendTo: (parent) ->
    super(parent)
    window.setTimeout((=> @refreshScroll()), 1000)

  switchView: (viewName) ->
    super(viewName)
    @refreshScroll()

  refreshScroll: ->
    console.log "refreshing @iScroll"
    window.setTimeout((=> @iScroll.refresh()), 0)

