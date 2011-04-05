storageNamespacePrefix   = "nnnnext"
unsyncedStorageNamespace = "#{storageNamespacePrefix}/unsynced"
storageNamespace         = null

if UserInfo?
  storageNamespace = "#{storageNamespacePrefix}/#{UserInfo._id}"

  # Copy unsynced albums into user namespace
  _.keys(localStorage).forEach (key) ->
    if key.search("#{unsyncedStorageNamespace}/") == 0
      value  = localStorage.getItem(key)
      newKey = key.replace(unsyncedStorageNamespace, storageNamespace)

      localStorage.setItem(newKey, value)
      localStorage.removeItem(key)

else
  storageNamespace = unsyncedStorageNamespace

SavedAlbums = new AlbumCollection {
  localStorage: new Store("#{storageNamespace}/albums")
  sync:         Backbone.localSync
  comparator:   (a) -> -a.get("stateChanged")
}

