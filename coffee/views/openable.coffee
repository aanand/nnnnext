Views.Openable =
  toggleOpen: (e) ->
    if $(@el).hasClass('open')
      @close()
    else
      @open()

  open: ->
    unless $(@el).hasClass('open')
      $(@el)
        .addClass('touched')
        .addClass('open')

      window.setTimeout((=> $(@el).removeClass('touched')), 400)

      @list.albumOpened(this.model)

  close: ->
    $(@el).removeClass('open')
    @onClose.call(this) if @onClose?

