class AlbumSearch extends Backbone.View
  initialize: (options) ->
    @queueCollection = options.queueCollection

    @collection = new AlbumCollection()
    @bar        = new AlbumSearchBar({collection: @collection})
    @list       = new AlbumSearchList({collection: @collection})

    @setFocus('bar')

    @collection.bind "refresh", => @finishSearch()
    @list.bind "selectionExit", => @setFocus('bar')

  render: ->
    $(@el)
      .append(@bar.render().el)
      .append(@list.render().el)

    this

  setFocus: (f) ->
    @focus = f

    switch f
      when 'bar'
        @bar.focus()
      else
        @bar.blur()

  startSearch: ->
    @bar.showSpinner()
    @collection.url = "/albums/search?" + $.param({q: @bar.getQuery()})
    @collection.fetch()
    @trigger("startSearch")

  finishSearch: ->
    @bar.hideSpinner()
    @list.show()
    @trigger("finishSearch")

  selectAlbum: ->
    @queueCollection.add(@list.getSelection())

    @list.hide()
    @setFocus('bar')
    @bar.clear()

    @trigger("selectAlbum")

  moveSelectionUp: ->
    if @focus == 'bar'
      @setFocus('list')
      @list.selectLast()
    else
      @list.selectPrevious()
    
  moveSelectionDown: ->
    if @focus == 'bar'
      @setFocus('list')
      @list.selectFirst()
    else
      @list.selectNext()
    
  handleKeypress: (e) ->
    switch e.keyCode
      when 13
        if @focus == 'bar'
          @startSearch()
        else
          @selectAlbum()

      when 38
        e.preventDefault()
        @moveSelectionUp()

      when 40
        e.preventDefault()
        @moveSelectionDown()

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
    <input type="text"/>
    <div class="spinner" style="display:none"/>
  ')

  className: 'album-search-bar'

  render: ->
    $(@el).html(@template())
    this

  getQuery: -> @$("input").val()

  clear: -> @$('input').val('')
  focus: -> @$('input').focus()
  blur:  -> @$('input').blur()

  showSpinner: -> @$('.spinner').show()
  hideSpinner: -> @$('.spinner').hide()

