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

    _.bindAll(this, "navigate", "startSync", "finishSync", "handleKeypress", "showNavigation", "setHint", "refreshScroll")

    @navigation.bind  "navigate",        @navigate
    @header.bind      "syncButtonClick", @startSync
    @listManager.bind "addAlbum",        @showNavigation
    LocalSync.bind    "sync",            @startSync
    Sync.bind         "finish",          @finishSync
    CurrentAlbums.bind "add",            @setHint
    CurrentAlbums.bind "remove",         @setHint
    $(window).bind    "keydown",         @handleKeypress

    v.bind "update", @refreshScroll for v in @views

    @renderSubviews()

    @hideNavigation() if @isNewUser()

    @tabIndex = 0
    @navigate(@navigation.href)

    @startSync()

  initNavigation: ->
    @navigation = new UI.Navigation
    @navigation.href = "/current"
    @header.addNavigation(@navigation)

  hideNavigation: ->
    @navigation.hide()

  showNavigation: ->
    @navigation.show()

  renderSubviews: ->
    @el.append(@banner.render().el)
    @el.append(@header.render().el)
    @views.forEach (v) => @el.append(v.render().el)

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
      if window.navigator.standalone
        null
      else
        'AppHint'
    else if @isNewUser()
      'IntroHint'
    else if @hasOneAlbum()
      'FirstAlbumHint'
    else
      'SignInHint'

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
  hideNavigation: ->
    @header.hide()

  showNavigation: ->
    @header.show()

  appendTo: (parent) ->
    super(parent)
    @listManager.focusSearchBar()

