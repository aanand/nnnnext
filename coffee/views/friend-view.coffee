class Views.FriendView extends Views.View
  tagName: 'li'
  className: 'friend'

  template: _.template('
    <% if (backButton) { %>
      <div class="back"/>
    <% } %>

    <div class="info">
      <img src="<%= image %>"/>

      <div class="name"><%= name %></div>
      <div class="nickname"><%= nickname %></div>
    </div>
  ')

  events:
    keypress: "select"
    "click .back": "back"

  initialize: (options) ->
    @list = options.list
    @backButton = options.backButton ? false

    callback = =>
      $(@el).addClass('touched')
      window.setTimeout((=> @select()), 0)

    $(@el).tappable(callback: callback, touchDelay: TouchDelay)

  render: ->
    vars = @model.toJSON()
    vars.backButton = @backButton
    $(@el).html(@template(vars))
    this

  back: ->
    @trigger("back")

