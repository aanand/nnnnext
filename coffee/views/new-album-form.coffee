class NewAlbumForm extends Backbone.View
  tagName: 'li'
  className: 'new-album'

  events:
    "submit form": "triggerSubmit"
  
  template: _.template('
    <% if (nothingFound) { %>
      <div class="nothing-found">Nothing found in the library. Enter it manually:</div>
    <% } %>

    <form action="javascript:void(0);">
      <input type="text" name="artist" placeholder="Artist"/>
      <input type="text" name="title"  placeholder="Album Title"/>
      <button type="submit">Add</button>
    </form>
  ')

  initialize: (options) ->
    @nothingFound = options.nothingFound

  render: ->
    $(@el).html(@template(this))
    this

  triggerSubmit: (e) ->
    e.preventDefault()

    attributes = _.reduce(
      @$('input').serializeArray(),
      ((attrs, pair) -> attrs[pair.name] = pair.value; attrs),
      {}
    )

    album = new Album(attributes)

    @trigger("submit", album)

_.extend NewAlbumForm.prototype,
  getTabbableElements: ->
    @$('input').get()
