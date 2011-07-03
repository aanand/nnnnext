var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Views.View = (function() {
  __extends(View, Backbone.View);
  function View() {
    View.__super__.constructor.apply(this, arguments);
  }
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
  View.prototype.select = function(e) {
    if (e != null) {
      if (e.type === "keypress" && e.keyCode !== 13) {
        return;
      }
      e.preventDefault();
    }
    if (this.list != null) {
      return this.list.trigger("select", this.model);
    }
  };
  return View;
})();
Views.Tabbable = {
  setTabIndex: function(n) {
    this.tabIndex = n;
    this.getTabbableElements().forEach(function(e) {
      if (typeof e.setTabIndex === 'function') {
        return n = e.setTabIndex(n);
      } else {
        e.tabIndex = n;
        return n++;
      }
    });
    return n;
  },
  reTab: function() {
    if (this.tabIndex != null) {
      return this.setTabIndex(this.tabIndex);
    }
  },
  getTabbableElements: function() {
    return [this.el];
  }
};