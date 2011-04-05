class AlbumSearchBar extends View
  className: 'album-search-bar'
  tagName: 'form'

  template: _.template('
    <input type="text"/>
    <button type="submit">Search</button>
    <div class="spinner" style="display:none"/>
  ')

  events:
    "change input": "handleChange"
    "submit": "handleSubmit"

  initialize: ->
    _.bindAll(this, "handleKeypress")

  render: ->
    $(@el).html(@template())
    this

  handleKeypress: (e) ->
    return unless @$("input").is(":focus")

    switch e.keyCode
      when 27
        e.preventDefault()

        @clear()
        @trigger("clear")

  handleChange: (e) ->
    @trigger("clear") if @$("input").val() == ""

  handleSubmit: (e) ->
    e.preventDefault()

    val = @$("input").val()

    if val == ""
      @clear()
      @trigger("clear")
    else
      @trigger("submit", val)

  clear: -> @$('input').val(''); this
  focus: -> @$('input').focus(); this

  showSpinner: -> @$('.spinner').show()
  hideSpinner: -> @$('.spinner').hide()

_.extend AlbumSearchBar.prototype, Tabbable, {
  getTabbableElements: -> @$('input').get()
}

