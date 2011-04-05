class FriendView extends View
  tagName: 'li'

  template: _.template('
    <img src="<%= image %>"/>

    <div class="info">
      <div class="name"><%= name %></div>
      <div class="nickname"><%= nickname %></div>
    </div>
  ')

  events:
    "click": "handleClick"

  initialize: (options) ->
    @list = options.list

  render: ->
    $(@el).html(@template(@model.toJSON()))
    this

  handleClick: (e) ->
    e.preventDefault()
    @list.trigger("select", @model) if @list?

