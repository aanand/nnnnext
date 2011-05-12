class Views.AppView extends Views.View
  el: $('#app')

  initialize: ->
    SavedAlbums.fetch()

    $(@el).html(@template())

    @hideHeader() if @isNewUser()
    @hideAboutPage()

    @links     = new UI.Links({el: @$(".links")})
    @header    = new UI.Header({el: @$(".header")})
    @aboutPage = new UI.AboutPage({el: @$(".about-page")})

    @navigation = @header.navigation
    @navigation.href = "/current"

    @listManager   = new UI.ListManager
    @friendBrowser = new UI.FriendBrowser

    @views = [@listManager, @friendBrowser]

    @links.render()
    @header.render()
    @aboutPage.render()
    @views.forEach (v) => @$(".views").append(v.render().el)

    _.bindAll(this, "navigate", "showAboutPage", "hideAboutPage", "startSync", "finishSync", "handleKeypress", "showHeader", "setHint", "refreshScroll")

    @navigation.bind  "navigate",        @navigate
    @links.bind       "aboutClick",      @showAboutPage
    @aboutPage.bind   "dismiss",         @hideAboutPage
    @header.bind      "syncButtonClick", @startSync
    @listManager.bind "addAlbum",        @showHeader
    LocalSync.bind    "sync",            @startSync
    Sync.bind         "finish",          @finishSync
    CurrentAlbums.bind "add",            @setHint
    CurrentAlbums.bind "remove",         @setHint
    $(window).bind    "keydown",         @handleKeypress

    v.bind "update", @refreshScroll for v in @views

    @tabIndex = 0
    @navigate(@navigation.href)

    @startSync()
    @setHint()

  hideHeader: ->
    @$(".header").hide()

  showHeader: ->
    @$(".header").show()

  refreshScroll: ->

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

  showAboutPage: ->
    @$(".ui").hide()
    @$(".about-page").show()

  hideAboutPage: ->
    @$(".about-page").hide()
    @$(".ui").show()

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
  template: _.template('
    <div class="banner">
      <div class="title"/>
      <div class="links"/>
    </div>

    <div class="main">
      <div class="about-page"/>
      <div class="ui">
        <div class="header"/>
        <div class="views"/>
      </div>
    </div>
  ')

  initialize: (options) ->
    super(options)
    @listManager.focusSearchBar()

class Touch.AppView extends Views.AppView
  template: _.template('
    <div class="main">
      <div class="banner">
        <div class="title"/>
      </div>

      <div class="ui">
        <div class="header"/>
        <div class="views"/>
      </div>

      <div class="about-page"/>

      <div class="links"/>
    </div>
  ')

  initialize: (options) ->
    super(options)

    bannerHeight   = @$(".banner").outerHeight()
    linksHeight    = @$(".links").outerHeight()
    viewportHeight = $(window).height()

    minHeight = viewportHeight - bannerHeight - linksHeight

    @$(".ui, .about-page").css({minHeight: "#{minHeight}px"})

