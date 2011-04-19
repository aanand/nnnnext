(function($) {
  var touchSupported = ('ontouchstart' in window)

  $.fn.tap = function(callback) {
    var el = $(this)

    if (arguments.length) {
      if (touchSupported) {
        el
          .bind('touchstart', function() {
            el.addClass('touched')
            return true
          })
          .bind('touchend', function(event) {
            if (el.hasClass('touched')) {
              el.removeClass('touched')
              callback.call(this, event)
            }

            return true
          })
      } else {
        el.bind('click', callback)
      }
    } else {
      callback.call(this)
    }
  }

  $.fn.isScrollable = function(callback) {
    var el = $(this)

    el
      .bind('touchstart', function() {
        el.data('isScrolling', false)
        callback.call(this, false)
      })
      .bind('touchmove', function() {
        if (!el.data('isScrolling')) {
          el
            .data('isScrolling', true)
            .find('.touched').removeClass('touched')

          callback.call(this, true)
        }
      })
      .bind('touchend', function() {
        if (el.data('isScrolling')) {
          el.data('isScrolling', false)
        }

        callback.call(this, false)
      })
  }
})(jQuery);

