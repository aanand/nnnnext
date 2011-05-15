SavedAlbums = new AlbumCollection
  localStorage: new Store("#{LocalSync.ns}/albums")
  sync:         LocalSync.sync

CurrentAlbums = new FilteredCollection
  model:      Album
  parent:     SavedAlbums
  filter:     (a) -> a.get("state") == "current"
  comparator: (a) -> -a.get("stateChanged")

ArchivedAlbums = new FilteredCollection
  model:      Album
  parent:     SavedAlbums
  filter:     (a) -> a.get("state") == "archived"
  comparator: (a) -> -a.get("stateChanged")

Friends = new UserCollection

FriendsAlbums = new AlbumCollection

