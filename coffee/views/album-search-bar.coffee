class Views.AlbumSearchBar extends Views.View
  className: 'album-search-bar'
  tagName: 'form'

  template: _.template('
    <div class="input"><input type="text"/></div>
    <button type="submit">Search</button>
    <div class="spinner" style="display:none"/>
    <div class="cancel" style="display:none"/>
  ')

  events:
    submit: "handleSubmit"

  initialize: (options) ->
    _.bindAll(this, "handleKeypress", "cancel")
    @listManager = options.listManager

  render: ->
    $(@el).html(@template())
    @$(".cancel").tappable(@cancel)
    this

  handleKeypress: (e) ->
    window.setTimeout((=>@showOrHideCancel()), 0)

    return unless @$("input").is(":focus")

    switch e.keyCode
      when 27
        e.preventDefault()
        @cancel()

  handleSubmit: (e) ->
    e.preventDefault()

    if @val() == ""
      @cancel()
    else
      @trigger("submit", @val())

  showOrHideCancel: ->
    if @val() != "" or @listManager.isSearching()
      @$(".cancel").show()
    else
      @$(".cancel").hide()

  cancel: (e) ->
    e.preventDefault() if e

    @clear()
    @trigger("clear")
    @showOrHideCancel()

  val:   -> @$("input").val()
  clear: -> @$('input').val(''); this
  focus: -> @$('input').focus(); this
  blur:  -> @$('input').blur();  this

  showSpinner: -> @$('.spinner').show()
  hideSpinner: -> @$('.spinner').hide()

_.extend Views.AlbumSearchBar.prototype, Views.Tabbable, {
  getTabbableElements: -> @$('input').get()
}

