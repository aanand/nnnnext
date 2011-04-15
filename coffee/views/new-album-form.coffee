class Views.NewAlbumForm extends Views.View
  tagName: 'li'
  className: 'new-album'

  events:
    "submit form": "triggerSubmit"
  
  template: _.template('
    <form action="javascript:void(0);">
      <label for="artist">
        <% if (nothingFound) { %>
          Nothing found in the library. Enter it manually:
        <% } else { %>
          Didn’t find what you wanted? Enter it manually:
        <% } %>
      </label>

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

_.extend Views.NewAlbumForm.prototype, Views.Tabbable,
  getTabbableElements: ->
    @$('input').get()
