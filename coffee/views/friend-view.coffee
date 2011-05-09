class Views.FriendView extends Views.View
  tagName: 'li'
  className: 'friend'

  template: _.template('
    <% if (backButton) { %>
      <div class="back"/>
    <% } %>

    <img src="<%= image %>"/>

    <div class="info">
      <div class="name"><%= name %></div>
      <div class="nickname"><%= nickname %></div>
    </div>
  ')

  events:
    keypress: "select"
    "click .back": "back"

  initialize: (options) ->
    _.bindAll(this, "select")
    @list = options.list
    @backButton = options.backButton ? false
    $(@el).tappable(@select) if @list?

  render: ->
    vars = @model.toJSON()
    vars.backButton = @backButton
    $(@el).html(@template(vars))
    this

  back: ->
    @trigger("back")

