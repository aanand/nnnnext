class FilteredCollection extends Backbone.Collection
  initialize: (options) ->
    _.bindAll(this, "parentAdded", "parentRefreshed", "parentChanged")

    @parent     = options.parent
    @filter     = options.filter
    @comparator = options.comparator

    @parent.bind "add",     @parentAdded
    @parent.bind "refresh", @parentRefreshed
    @parent.bind "change",  @parentChanged

  parentAdded: (model) ->
    @add(model) if @filter(model)

  parentRefreshed: ->
    @refresh(@parent.models.filter(@filter))

  parentChanged: (model) ->
    haveModel       = (@models.indexOf(model) != -1)
    shouldHaveModel = @filter(model)

    if haveModel and !shouldHaveModel
      @remove(model)
    else if !haveModel and shouldHaveModel
      @add(model)

