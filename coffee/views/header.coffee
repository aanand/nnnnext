class Views.Header extends Views.View
  template: _.template('
    <div class="navigation"/>

    <div class="sync-controls" style="display:none">
      <div class="button"/>
      <div class="spinner" style="display: none"/>
    </div>
  ')

  events:
    "click .sync-controls .button": "syncClick"

  initialize: ->
    @navigation = new UI.Navigation

  render: ->
    $(@el).html(@template())
    @navigation.el = @$(".navigation")
    @navigation.render()
    this

  syncClick: (e) ->
    @trigger("syncButtonClick")

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

