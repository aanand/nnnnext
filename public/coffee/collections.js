var ArchivedAlbums, CurrentAlbums, Friends, FriendsAlbums, SavedAlbums;
SavedAlbums = new AlbumCollection({
  localStorage: new Store("" + LocalSync.ns + "/albums"),
  sync: LocalSync.sync
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
Friends = new UserCollection;
Friends.url = "/friends";
FriendsAlbums = new AlbumCollection;