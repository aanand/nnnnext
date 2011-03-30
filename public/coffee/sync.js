var Sync;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
Sync = {
  start: function(collection, url) {
    var json;
    json = JSON.stringify(collection.models.map(function(a) {
      return a.attributes;
    }));
    return $.ajax({
      type: "POST",
      url: url,
      contentType: "application/json",
      data: json,
      success: __bind(function(albums) {
        return this.sync(collection, albums, url);
      }, this)
    });
  },
  sync: function(collection, serverAlbums, url) {
    var resync;
    resync = false;
    serverAlbums.forEach(__bind(function(serverAlbum) {
      var clientAlbum, updatedOnClient;
      clientAlbum = collection.get(serverAlbum.id);
      if (clientAlbum != null) {
        updatedOnClient = clientAlbum.get("updated");
        if (updatedOnClient < serverAlbum.updated) {
          console.log("Album " + serverAlbum.id + " is behind on client (" + updatedOnClient + " < " + serverAlbum.updated + "). Updating.");
          clientAlbum.set(serverAlbum);
          return clientAlbum.save();
        } else if (updatedOnClient > serverAlbum.updated) {
          console.log("Album " + serverAlbum.id + " is behind on server. (" + updatedOnClient + " > " + serverAlbum.updated + ") Going to re-sync.");
          return resync = true;
        } else {
          return console.log("Album " + serverAlbum.id + " is in sync (" + updatedOnClient + " == " + serverAlbum.updated + ").");
        }
      } else {
        console.log("Album " + serverAlbum.id + " does not exist on client. Creating.");
        return clientAlbum = collection.create(serverAlbum);
      }
    }, this));
    if (resync) {
      return this.start(collection, url);
    } else {
      return this.trigger("finish");
    }
  }
};
_.extend(Sync, Backbone.Events);