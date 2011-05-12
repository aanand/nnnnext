var Album;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Album = (function() {
  function Album() {
    Album.__super__.constructor.apply(this, arguments);
  }
  __extends(Album, Backbone.Model);
  Album.prototype.sync = LocalSync.sync;
  Album.prototype.addTo = function(collection) {
    this.collection = collection;
    this.collection.add(this);
    return this.update({
      state: "current"
    });
  };
  Album.prototype.rate = function(rating) {
    return this.update({
      rating: rating
    });
  };
  Album.prototype.archive = function() {
    return this.update({
      state: "archived"
    });
  };
  Album.prototype.restore = function() {
    return this.update({
      state: "current"
    });
  };
  Album.prototype["delete"] = function() {
    return this.update({
      state: "deleted"
    });
  };
  Album.prototype.update = function(attrs) {
    attrs.updated = new Date().getTime();
    if ((attrs.state != null) && attrs.state !== this.get("state")) {
      attrs.stateChanged = attrs.updated;
    }
    this.set(attrs);
    this.save();
    if (this.collection) {
      return this.collection.trigger("update");
    }
  };
  Album.prototype.removeView = function() {
    this.view.remove();
    return delete this.view;
  };
  return Album;
})();