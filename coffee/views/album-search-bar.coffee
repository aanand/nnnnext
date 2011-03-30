class AlbumSearchBar extends Backbone.View
  template: _.template('
    <input type="text"/>
    <div class="spinner" style="display:none"/>
  ')

  events:
    "change input": "handleChange"

  className: 'album-search-bar'

  initialize: ->
    _.bindAll(this, "handleKeypress")

  render: ->
    $(@el).html(@template())
    this

  handleKeypress: (e) ->
    return unless @$("input").is(":focus")

    switch e.keyCode
      when 13
        e.preventDefault()

        val = @$("input").val()

        if val == ""
          @clear()
          @trigger("clear")
        else
          @trigger("submit", val)

      when 27
        e.preventDefault()

        @clear()
        @trigger("clear")

  handleChange: (e) ->
    @trigger("clear") if @$("input").val() == ""

  clear: -> @$('input').val(''); this
  focus: -> @$('input').focus(); this

  showSpinner: -> @$('.spinner').show()
  hideSpinner: -> @$('.spinner').hide()

_.extend AlbumSearchBar.prototype, Tabbable, {
  getTabbableElements: -> @$('input').get()
}

