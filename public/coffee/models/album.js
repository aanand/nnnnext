var Album, AlbumCollection;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
Album = (function() {
  function Album() {
    Album.__super__.constructor.apply(this, arguments);
  }
  __extends(Album, Backbone.Model);
  Album.prototype.sync = Backbone.localSync;
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
    return this.save();
  };
  Album.prototype.save = function(attrs, options) {
    var originalSuccess;
    if (this.collection != null) {
      options || (options = {});
      originalSuccess = options.success;
      options.success = __bind(function(model, resp) {
        if (originalSuccess != null) {
          originalSuccess(model, resp);
        }
        this.collection.sort();
        return this.collection.trigger("modelSaved", this);
      }, this);
    }
    return Album.__super__.save.call(this, attrs, options);
  };
  Album.prototype.destroy = function(options) {
    var coll, originalSuccess;
    coll = this.collection;
    if (coll != null) {
      options || (options = {});
      originalSuccess = options.success;
      options.success = __bind(function(model, resp) {
        if (originalSuccess != null) {
          originalSuccess(model, resp);
        }
        return coll.trigger("modelDestroyed", this);
      }, this);
    }
    return Album.__super__.destroy.call(this, options);
  };
  return Album;
})();
AlbumCollection = (function() {
  function AlbumCollection() {
    AlbumCollection.__super__.constructor.apply(this, arguments);
  }
  __extends(AlbumCollection, Backbone.Collection);
  AlbumCollection.prototype.model = Album;
  AlbumCollection.prototype.initialize = function(options) {
    if (options != null) {
      this.localStorage = options.localStorage;
      this.sync = options.sync;
      return this.comparator = options.comparator;
    }
  };
  AlbumCollection.prototype.deDupe = function() {
    var map;
    map = {};
    return this.models.forEach(function(album) {
      var dupe;
      dupe = map[album.id];
      if (dupe != null) {
        if (album.get("updated") < dupe.get("updated")) {
          console.log("Destroying old duplicate of album " + album.id + " (" + (album.get("updated")) + " < " + (dupe.get("updated")) + ")");
          return album.destroy();
        } else {
          console.log("Destroying old duplicate of album " + album.id + " (" + (dupe.get("updated")) + " < " + (album.get("updated")) + ")");
          dupe.destroy();
          return map[album.id] = album;
        }
      } else {
        return map[album.id] = album;
      }
    });
  };
  return AlbumCollection;
})();