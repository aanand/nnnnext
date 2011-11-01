var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
Views.List = (function() {
  __extends(List, Views.View);
  function List() {
    List.__super__.constructor.apply(this, arguments);
  }
  List.prototype.tagName = 'ul';
  List.prototype.initialize = function(options) {
    return _.bindAll(this, "populate");
  };
  List.prototype.populate = function() {
    $(this.el).empty();
    this.collection.forEach(__bind(function(model) {
      var view;
      view = this.makeView(model);
      $(this.el).append(view.el);
      return view.render();
    }, this));
    return this.reTab();
  };
  List.prototype.setHint = function(hint) {
    if (this.hint != null) {
      this.hint.remove();
      this.$(".hint-container").remove();
    }
    this.hint = hint;
    if (this.hint != null) {
      return this.appendHint(this.hint);
    }
  };
  List.prototype.appendHint = function(hint) {
    return $('<li class="hint-container"/>').append(hint.render().el).appendTo(this.el);
  };
  return List;
})();
_.extend(Views.List.prototype, Views.Tabbable, {
  getTabbableElements: function() {
    return this.collection.models.map(function(m) {
      return m.view.el;
    });
  }
});