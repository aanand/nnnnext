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
    mouseover: "highlight"
    mouseout:  "highlight"
    focus:     "highlight"
    blur:      "highlight"
    click:    "select"
    keypress: "select"

  initialize: (options) ->
    @list = options.list

  render: ->
    $(@el).html(@template(@model.toJSON()))
    this

