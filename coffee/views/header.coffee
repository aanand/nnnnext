class Views.Header extends Views.View
  className: 'header'

  template: _.template('
    <div class="sync-controls" style="display:none">
      <div class="button"/>
      <div class="spinner" style="display: none"/>
    </div>
  ')

  events:
    "click .sync-controls .button": "syncClick"

  render: ->
    $(@el).html(@template())
    $(@el).append(@navigation.render().el) if @navigation?
    this

  syncClick: (e) ->
    @trigger("syncButtonClick")

  addNavigation: (navigation) ->
    @navigation = navigation
    navigation.header = this

  syncing: (inProgress) ->
    @$(".sync-controls").show()

    if inProgress
      @$(".sync-controls .button").hide()
      @$(".sync-controls .spinner").show()
    else
      @$(".sync-controls .button").show()
      @$(".sync-controls .spinner").hide()

class Desktop.Header extends Views.Header
  show: ->
    $(@el).slideDown('fast')

