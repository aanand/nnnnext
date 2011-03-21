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

  initialize: ->
    _.bindAll(this, "addOne", "populate")

    @collection.bind "add",     @addOne
    @collection.bind "refresh", @populate

  addOne: (album) ->
    $(@el).prepend(@makeView(album).render().el)

  populate: ->
    $(@el).empty()
    @collection.forEach (album) =>
      $(@el).append(@makeView(album).render().el)

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

class AlbumSearchList extends AlbumList
  itemTemplate: _.template('
    <div class="title"><%= title %></div>
    <div class="artist"><%= artist %></div>
  ')

  className: "#{AlbumList.prototype.className} album-search-list"

  select: (index) ->
    if index < 0 or index >= @collection.length
      @selectedIndex = null
      @trigger("selectionExit")
    else
      @selectedIndex = index

    @setHighlight()

  selectFirst:    -> @select(0)
  selectLast:     -> @select(@collection.length-1)
  selectPrevious: -> @select(@selectedIndex-1)
  selectNext:     -> @select(@selectedIndex+1)

  getSelection: ->
    return null unless @selectedIndex?
    @collection.at(@selectedIndex)

  setHighlight: ->
    @$('.selected').removeClass('selected')

    if album = @getSelection()
      $(album.view.el).addClass('selected')

class AlbumSearchBar extends Backbone.View
  template: _.template('
    <label>What are you listening to?</label>
    <input type="text"/>
    <div class="spinner" style="display:none"/>
  ')

  className: 'album-search-bar'

  render: ->
    $(@el).html(@template())
    this

  clear: -> @$('input').val('')
  focus: -> @$('input').focus()
  blur:  -> @$('input').blur()

  showSpinner: -> @$('.spinner').show()
  hideSpinner: -> @$('.spinner').hide()

