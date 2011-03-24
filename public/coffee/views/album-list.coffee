class AlbumList extends Backbone.View
  tagName: 'ul'
  className: 'album-list'

  populateMethod: 'append'

  initialize: (options) ->
    _.bindAll(this, "addOne", "populate", "show", "hide")

    @collection.bind "add",     @addOne
    @collection.bind "refresh", @populate

  addOne: (album) ->
    view       = new AlbumView({model: album, template: @itemTemplate, list: this})
    album.view = view
    el         = view.render().el

    index    = @collection.indexOf(album)
    children = $(@el).children()

    if children[index]
      $(el).insertBefore(children[index])
    else
      $(el).appendTo(@el)

  populate: ->
    $(@el).empty()
    @collection.forEach (album) => @addOne(album)

  show: -> $(@el).show()
  hide: -> $(@el).hide()

_.extend AlbumList.prototype, Tabbable, {
  getTabbableElements: ->
    @collection.map (album) -> album.view.el
}

class CurrentAlbumsList extends AlbumList
  itemTemplate: _.template('
    <div class="title"><%= title %></div>
    <div class="artist"><%= artist %></div>
  ')

  className: "#{AlbumList.prototype.className} current-albums-list"

class AlbumSearchList extends AlbumList
  itemTemplate: _.template('
    <div class="title"><%= title %></div>
    <div class="artist"><%= artist %></div>
  ')

  className: "#{AlbumList.prototype.className} album-search-list"

