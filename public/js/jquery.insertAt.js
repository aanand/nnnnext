;(function($) {
  $.fn.insertAt = function(el, index) {
    el = $(el)

    var childToInsertBefore = this.children()[index]

    if (typeof childToInsertBefore !== 'undefined') {
      el.insertBefore(childToInsertBefore)
    } else {
      el.appendTo(this)
    }
  }
})(jQuery);

