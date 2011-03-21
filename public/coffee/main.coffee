window.Albums      = new AlbumCollection
window.AlbumSearch = new AlbumCollection

class AppView extends Backbone.View
  el: $('#app')

  initialize: ->
    @albumSearchBar     = new AlbumSearchBar({collection: AlbumSearch})
    @albumSearchList    = new AlbumSearchList({collection: AlbumSearch})
    @currentAlbumsList  = new CurrentAlbumsList({collection: Albums})

    @el.append(@albumSearchBar.render().el)
    @el.append(@albumSearchList.render().el)
    @el.append(@currentAlbumsList.render().el)

    @setFocus('bar')

    $(window).keydown (e) =>
      switch e.keyCode
        when 13
          if @focus == 'bar'
            @albumSearchBar.showSpinner()

            $.getJSON "/albums/search", {q: @$("input").val()}, (models) =>
              AlbumSearch.refresh(models)
              @albumSearchBar.hideSpinner()
              @currentAlbumsList.hide()
              @albumSearchList.show()

          else
            album = @albumSearchList.getSelection()
            Albums.add(album)
            album.save()

            @albumSearchList.hide()
            @currentAlbumsList.show()
            @setFocus('bar')
            @albumSearchBar.clear()

        when 38
          e.preventDefault()

          if @focus == 'bar'
            @setFocus('list')
            @albumSearchList.selectLast()
          else
            @albumSearchList.selectPrevious()

        when 40
          e.preventDefault()

          if @focus == 'bar'
            @setFocus('list')
            @albumSearchList.selectFirst()
          else
            @albumSearchList.selectNext()

    @albumSearchList.bind "selectionExit", => @setFocus('bar')

    Albums.fetch()

  setFocus: (f) ->
    @focus = f

    switch f
      when 'bar'
        @albumSearchBar.focus()
      else
        @albumSearchBar.blur()

window.App = new AppView
