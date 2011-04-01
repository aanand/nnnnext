class Banner extends Backbone.View
  className: 'banner'

  template: _.template('
    <div class="title"/>
    <div class="slogan"/>
    <div class="login">
      <a href="/auth/twitter"/>
    </div>
  ')

  render: ->
    $(@el).html(@template())
    this

