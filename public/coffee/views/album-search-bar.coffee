class AlbumSearchBar extends Backbone.View
  template: _.template('
    <input type="text"/>
    <div class="spinner" style="display:none"/>
  ')

  className: 'album-search-bar'

  initialize: ->
    _.bindAll(this, "handleKeypress")

  render: ->
    $(@el).html(@template())
    @$('input').keypress(@handleKeypress)
    this

  handleKeypress: (e) ->
    return unless e.keyCode == 13
    e.preventDefault()
    @trigger("submit", @$("input").val())

  clear: -> @$('input').val(''); this
  focus: -> @$('input').focus(); this

  showSpinner: -> @$('.spinner').show()
  hideSpinner: -> @$('.spinner').hide()

_.extend AlbumSearchBar.prototype, Tabbable, {
  getTabbableElements: -> @$('input').get()
}

