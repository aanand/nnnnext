var ArchivedAlbums, CurrentAlbums, SavedAlbums, storageNamespace, storageNamespacePrefix, unsyncedStorageNamespace;
storageNamespacePrefix = "nnnnext";
unsyncedStorageNamespace = "" + storageNamespacePrefix + "/unsynced";
storageNamespace = null;
if (typeof UserInfo != "undefined" && UserInfo !== null) {
  storageNamespace = "" + storageNamespacePrefix + "/" + UserInfo._id;
  _.keys(localStorage).forEach(function(key) {
    var newKey, value;
    if (key.search("" + unsyncedStorageNamespace + "/") === 0) {
      value = localStorage.getItem(key);
      newKey = key.replace(unsyncedStorageNamespace, storageNamespace);
      localStorage.setItem(newKey, value);
      return localStorage.removeItem(key);
    }
  });
} else {
  storageNamespace = unsyncedStorageNamespace;
}
SavedAlbums = new AlbumCollection({
  localStorage: new Store("" + storageNamespace + "/albums"),
  sync: Backbone.localSync
});
CurrentAlbums = new FilteredCollection({
  model: Album,
  parent: SavedAlbums,
  filter: function(a) {
    return a.get("state") === "current";
  },
  comparator: function(a) {
    return -a.get("stateChanged");
  }
});
ArchivedAlbums = new FilteredCollection({
  model: Album,
  parent: SavedAlbums,
  filter: function(a) {
    return a.get("state") === "archived";
  },
  comparator: function(a) {
    return -a.get("stateChanged");
  }
});