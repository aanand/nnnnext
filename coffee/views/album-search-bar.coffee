class Views.AlbumSearchBar extends Views.View
  className: 'album-search-bar'
  tagName: 'form'

  events:
    "click .cancel": "cancel"
    "submit":        "handleSubmit"

  initialize: (options) ->
    _.bindAll(this, "handleKeypress")
    @listManager = options.listManager

  render: ->
    $(@el).html(@template())
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
    @focus()
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

class Desktop.AlbumSearchBar extends Views.AlbumSearchBar
  template: _.template('
    <input type="text"/>
    <button type="submit">Search</button>
    <div class="spinner" style="display:none"/>
    <div class="cancel" style="display:none"/>
  ')

class Touch.AlbumSearchBar extends Views.AlbumSearchBar
  template: _.template('
    <div class="inner">
      <input type="text"/>
    </div>
  ')

  handleChange: (e) ->
    super(e)
    @trigger("submit", @val()) unless @val() == ""

