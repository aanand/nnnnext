class AlbumView extends Backbone.View
  tagName: 'li'

  initialize: (options) ->
    _.bindAll(this, 'render')
    @template = options.template
    @model.view = this

  render: ->
    $(@el).html(@template(@model.toJSON()))
    this

  remove: ->
    $(@el).remove()

  clear: ->
    @model.clear()

class AlbumList extends Backbone.View
  tagName: 'ul'
  className: 'album-list'

  populateMethod: 'append'

  initialize: (options) ->
    _.bindAll(this, "addOne", "populate", "show", "hide")

    @collection.bind "add",     @addOne
    @collection.bind "refresh", @populate

  addOne: (album) ->
    $(@el).prepend(@makeView(album).render().el)

  populate: ->
    $(@el).empty()
    @collection.forEach (album) =>
      $(@el)[@populateMethod](@makeView(album).render().el)

  makeView: (album) ->
    new AlbumView({model: album, template: @itemTemplate})

  show: -> $(@el).show()
  hide: -> $(@el).hide()

class CurrentAlbumsList extends AlbumList
  itemTemplate: _.template('
    <div class="title"><%= title %></div>
    <div class="artist"><%= artist %></div>
  ')

  className: "#{AlbumList.prototype.className} current-albums-list"

  populateMethod: 'prepend'

