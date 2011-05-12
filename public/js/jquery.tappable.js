;(function($) {
  var touchSupported = ('ontouchstart' in window)

  $.fn.tappable = function(options) {
    var cancelOnMove = true,
        onlyIf = function() { return true },
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

        if (typeof options.onlyIf != 'undefined') {
          onlyIf = options.onlyIf
        }

        break;
    }

    if (touchSupported) {
      this.bind('touchstart', function() {
        if (onlyIf(this)) {
          $(this).addClass('touched')
        }
        return true
      })

      this.bind('touchend', function(event) {
        if ($(this).hasClass('touched')) {
          $(this).removeClass('touched')

          if (typeof callback == 'function' && onlyIf(this)) {
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
      this.bind('click', function(event) {
        if (typeof callback == 'function' && onlyIf(this)) {
          callback.call(this, event)
        }
      })
    }

    return this
  }
})(jQuery);

