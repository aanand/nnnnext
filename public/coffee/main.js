var AlbumSearchResults, App, AppView, SavedAlbums, storageNamespace, storageNamespacePrefix, unsyncedStorageNamespace;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
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
  sync: Backbone.localSync,
  comparator: function(a) {
    return -a.get("stateChanged");
  }
});
AlbumSearchResults = new AlbumCollection;
AppView = (function() {
  function AppView() {
    AppView.__super__.constructor.apply(this, arguments);
  }
  __extends(AppView, Backbone.View);
  AppView.prototype.el = $('#app');
  AppView.prototype.initialize = function() {
    SavedAlbums.fetch();
    this.banner = new Banner;
    this.header = new Header;
    this.header.href = "/current";
    if (SavedAlbums.length > 0) {
      this.header.section = "nav";
    } else {
      this.header.section = "intro";
    }
    this.searchBar = new AlbumSearchBar({
      collection: AlbumSearchResults
    });
    this.searchResultsList = new AlbumSearchList({
      collection: AlbumSearchResults
    });
    this.savedAlbumsList = new SavedAlbumsList({
      collection: SavedAlbums
    });
    this.friendList = new FriendList;
    this.views = [this.searchResultsList, this.savedAlbumsList, this.friendList];
    _.bindAll(this, "navigate", "addAlbum", "startSearch", "finishSearch", "cancelSearch", "startSync", "finishSync", "handleKeypress");
    this.header.bind("navigate", this.navigate);
    this.header.bind("syncButtonClick", this.startSync);
    this.searchBar.bind("submit", this.startSearch);
    this.searchBar.bind("clear", this.cancelSearch);
    this.searchResultsList.bind("select", this.addAlbum);
    AlbumSearchResults.bind("refresh", this.finishSearch);
    SavedAlbums.bind("modelSaved", this.startSync);
    Sync.bind("finish", this.finishSync);
    $(window).bind("keydown", this.handleKeypress);
    this.el.append(this.banner.render().el);
    this.el.append(this.header.render().el);
    this.el.append(this.searchBar.render().el);
    this.el.append(this.searchResultsList.render().el);
    this.el.append(this.savedAlbumsList.render().el);
    this.el.append(this.friendList.render().el);
    this.savedAlbumsList.populate();
    this.savedAlbumsList.filter("current");
    this.switchView("savedAlbumsList");
    this.searchBar.focus();
    return this.startSync();
  };
  AppView.prototype.startSync = function() {
    if (typeof UserInfo == "undefined" || UserInfo === null) {
      return;
    }
    this.header.syncing(true);
    return Sync.start(SavedAlbums, "/albums/sync");
  };
  AppView.prototype.finishSync = function() {
    window.setTimeout((__bind(function() {
      return this.header.syncing(false);
    }, this)), 500);
    if (SavedAlbums.length > 0) {
      return this.header.switchTo("nav");
    }
  };
  AppView.prototype.navigate = function(href) {
    switch (href) {
      case "/current":
        this.switchView("savedAlbumsList");
        return this.savedAlbumsList.filter("current");
      case "/archived":
        this.switchView("savedAlbumsList");
        return this.savedAlbumsList.filter("archived");
      case "/friends":
        return this.switchView("friendList");
    }
  };
  AppView.prototype.handleKeypress = function(e) {
    switch (e.keyCode) {
      case 38:
        e.preventDefault();
        return this.tab(-1);
      case 40:
        e.preventDefault();
        return this.tab(+1);
      default:
        return this.searchBar.handleKeypress(e);
    }
  };
  AppView.prototype.tab = function(offset) {
    var focus, indices, nextIndex, nextIndexIndex;
    focus = $(':focus')[0];
    if (focus != null) {
      indices = $("[tabindex]").get().map(function(e) {
        return e.tabIndex;
      });
      nextIndexIndex = (_.indexOf(indices, focus.tabIndex) + offset + indices.length) % indices.length;
      nextIndex = indices[nextIndexIndex];
      return $("[tabindex=" + nextIndex + "]").focus();
    }
  };
  AppView.prototype.startSearch = function(query) {
    if (!query) {
      return;
    }
    this.searchBar.showSpinner();
    AlbumSearchResults.url = "/albums/search?" + $.param({
      q: query
    });
    return AlbumSearchResults.fetch();
  };
  AppView.prototype.finishSearch = function() {
    this.searchBar.hideSpinner();
    this.searchResultsList.populate();
    return this.switchView("searchResultsList");
  };
  AppView.prototype.cancelSearch = function() {
    return this.switchView("savedAlbumsList");
  };
  AppView.prototype.addAlbum = function(album) {
    album.addTo(SavedAlbums);
    this.switchView("savedAlbumsList");
    this.searchBar.clear().focus();
    return this.header.switchTo("nav");
  };
  AppView.prototype.switchView = function(listName) {
    this.views.forEach(function(l) {
      return l.hide();
    });
    this.currentView = this[listName];
    this.currentView.show();
    return this.setTabIndex(0);
  };
  return AppView;
})();
_.extend(AppView.prototype, Tabbable, {
  getTabbableElements: function() {
    return this.searchBar.getTabbableElements().concat(this.currentView.getTabbableElements());
  }
});
App = new AppView;