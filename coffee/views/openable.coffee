Views.Openable =
  toggleOpen: (e) ->
    if $(@el).hasClass('open')
      @close()
    else
      @open()

  open: ->
    unless $(@el).hasClass('open')
      $(@el).addClass('open')
      @list.albumOpened(this.model)

  close: ->
    $(@el).removeClass('open')
    @onClose.call(this) if @onClose?

