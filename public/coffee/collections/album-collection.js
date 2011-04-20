var AlbumCollection;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
AlbumCollection = (function() {
  function AlbumCollection() {
    AlbumCollection.__super__.constructor.apply(this, arguments);
  }
  __extends(AlbumCollection, Backbone.Collection);
  AlbumCollection.prototype.model = Album;
  AlbumCollection.prototype.initialize = function(options) {
    if (options != null) {
      this.localStorage = options.localStorage;
      return this.sync = options.sync;
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