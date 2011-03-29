class SyncingMessage extends Backbone.View
  template: _.template('
    <div class="spinner"/>
    Syncing...
  ')

  render: ->
    $(@el).html(@template()).hide()
    this

  show: -> $(@el).show()
  hide: -> $(@el).hide()
      
