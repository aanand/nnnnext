class FriendView extends View
  tagName: 'li'
  className: 'friend'

  template: _.template('
    <img src="<%= image %>"/>

    <div class="info">
      <div class="name"><%= name %></div>
      <div class="nickname"><%= nickname %></div>
    </div>
  ')

  events:
    click:    "select"
    keypress: "select"

  initialize: (options) ->
    @list = options.list

    unless options.highlightable == false
      _.bindAll(this, "highlight")

      $(@el)
        .bind("mouseover", @highlight)
        .bind("mouseout",  @highlight)
        .bind("focus",     @highlight)
        .bind("blur",      @highlight)

  render: ->
    $(@el).html(@template(@model.toJSON()))
    this

