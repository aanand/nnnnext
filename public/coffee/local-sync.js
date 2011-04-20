var LocalSync;
LocalSync = {
  sync: function(method, model, options) {
    var ret;
    ret = Backbone.localSync(method, model, options);
    this.trigger("sync", method, model, options);
    return ret;
  },
  migrate: function(oldNS, newNS) {
    var key, newKey, value, _i, _len, _ref, _results;
    _ref = _.keys(localStorage);
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      key = _ref[_i];
      _results.push(key.search("" + oldNS + "/") === 0 ? (value = localStorage.getItem(key), newKey = key.replace(oldNS, newNS), console.log("Moving " + key + " to " + newKey), localStorage.setItem(newKey, value), localStorage.removeItem(key)) : void 0);
    }
    return _results;
  }
};
LocalSync.nsPrefix = "nnnnext";
LocalSync.unsyncedNS = "" + LocalSync.nsPrefix + "/unsynced";
if (typeof UserInfo != "undefined" && UserInfo !== null) {
  LocalSync.ns = "" + LocalSync.nsPrefix + "/" + UserInfo._id;
  LocalSync.migrate(LocalSync.unsyncedNS, LocalSync.ns);
} else {
  LocalSync.ns = LocalSync.unsyncedNS;
}
_.bindAll(LocalSync, "sync");
_.extend(LocalSync, Backbone.Events);