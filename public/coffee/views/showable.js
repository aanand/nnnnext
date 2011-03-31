_.extend(Backbone.View.prototype, {
  show: function() {
    return $(this.el).show();
  },
  hide: function() {
    return $(this.el).hide();
  }
});