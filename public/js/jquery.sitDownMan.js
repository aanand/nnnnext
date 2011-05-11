;(function($) {
  $.fn.sitDownMan = function() {
    this.click(function(e) {
      e.preventDefault()
      window.location = this.href
    })
  }
})(jQuery);

