class Banner extends Backbone.View
  className: 'banner'

  template: _.template('
    <div class="title"/>
    <div class="slogan"/>
    <a class="login" href="/auth/twitter"/>
  ')

  render: ->
    $(@el).html(@template())
    this

