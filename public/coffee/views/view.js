var View;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
View = (function() {
  function View() {
    View.__super__.constructor.apply(this, arguments);
  }
  __extends(View, Backbone.View);
  View.prototype.show = function() {
    this.trigger("show");
    return $(this.el).show();
  };
  View.prototype.hide = function() {
    this.trigger("hide");
    return $(this.el).hide();
  };
  View.prototype.switchView = function(viewName) {
    this.views.forEach(function(v) {
      return v.hide();
    });
    this.currentView = this[viewName];
    this.currentView.show();
    if (typeof this.reTab === 'function') {
      return this.reTab();
    }
  };
  return View;
})();