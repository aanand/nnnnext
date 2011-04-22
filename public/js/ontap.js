(function($) {
  var touchSupported = ('ontouchstart' in window)

  $.fn.tappable = function(options) {
    var cancelOnMove = true,
        callback

    switch(typeof options) {
      case 'function':
        callback = options
        break;
      case 'object':
        callback = options.callback

        if (typeof options.cancelOnMove != 'undefined') {
          cancelOnMove = options.cancelOnMove
        }

        break;
    }

    if (touchSupported) {
      this.bind('touchstart', function() {
        $(this).addClass('touched')
        return true
      })

      this.bind('touchend', function(event) {
        if ($(this).hasClass('touched')) {
          $(this).removeClass('touched')

          if (typeof callback == 'function') {
            callback.call(this, event)
          }
        }

        return true
      })

      this.bind('click', function(event) {
        event.preventDefault()
      })

      if (cancelOnMove) {
        this.bind('touchmove', function() {
          if ($(this).hasClass('touched')) {
            $(this).removeClass('touched')
          }
        })
      }
    } else if (typeof callback == 'function') {
      this.bind('click', callback)
    }

    return this
  }
})(jQuery);

