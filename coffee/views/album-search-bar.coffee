class AlbumSearchBar extends View
  className: 'album-search-bar'
  tagName: 'form'

  template: _.template('
    <div class="inner">
      <input type="text"/>
      <button type="submit">Search</button>
      <div class="spinner" style="display:none"/>
    </div>
  ')

  events:
    "change input": "handleChange"
    "submit": "handleSubmit"

  initialize: ->
    _.bindAll(this, "handleKeypress")

  render: ->
    $(@el).html(@template())
    @$('button').hide() if Mobile
    this

  handleKeypress: (e) ->
    return unless @$("input").is(":focus")

    switch e.keyCode
      when 27
        e.preventDefault()

        @clear()
        @trigger("clear")

  handleChange: (e) ->
    if @val() == ""
      @trigger("clear")
    else if Mobile
      @trigger("submit", @val())

  handleSubmit: (e) ->
    e.preventDefault()

    if @val() == ""
      @clear()
      @trigger("clear")
    else
      @trigger("submit", @val())

  val:   -> @$("input").val()
  clear: -> @$('input').val(''); this
  focus: -> @$('input').focus(); this
  blur:  -> @$('input').blur();  this

  showSpinner: -> @$('.spinner').show()
  hideSpinner: -> @$('.spinner').hide()

_.extend AlbumSearchBar.prototype, Tabbable, {
  getTabbableElements: -> @$('input').get()
}

