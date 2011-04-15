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
    click:    "select"
    keypress: "select"
    "click .back": "back"

  initialize: (options) ->
    @list = options.list
    @backButton = options.backButton ? false

    unless options.highlightable == false
      _.bindAll(this, "highlight")

      $(@el)
        .bind("mouseover", @highlight)
        .bind("mouseout",  @highlight)
        .bind("focus",     @highlight)
        .bind("blur",      @highlight)

  render: ->
    vars = @model.toJSON()
    vars.backButton = @backButton
    $(@el).html(@template(vars))
    this

  back: ->
    @trigger("back")

