var AlbumSearchResults, App, AppView, SavedAlbums;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
SavedAlbums = new AlbumCollection({
  localStorage: new Store("albums"),
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
    this.lists = [this.searchResultsList, this.savedAlbumsList];
    _.bindAll(this, "navigate", "addAlbum", "startSearch", "finishSearch", "cancelSearch", "startSync", "startSyncOrSignIn", "finishSync", "handleKeypress");
    this.header.bind("navigate", this.navigate);
    this.header.bind("syncButtonClick", this.startSyncOrSignIn);
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
    this.savedAlbumsList.populate();
    this.savedAlbumsList.filter("current");
    this.switchList("savedAlbumsList");
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
  AppView.prototype.startSyncOrSignIn = function() {
    if (typeof UserInfo != "undefined" && UserInfo !== null) {
      return this.startSync();
    } else {
      if (window.confirm("Sign in with Twitter to start saving your list?")) {
        return window.location.href = "/auth/twitter";
      }
    }
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
        return this.savedAlbumsList.filter("current");
      case "/archived":
        return this.savedAlbumsList.filter("archived");
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
    return this.switchList("searchResultsList");
  };
  AppView.prototype.cancelSearch = function() {
    return this.switchList("savedAlbumsList");
  };
  AppView.prototype.addAlbum = function(album) {
    album.addTo(SavedAlbums);
    this.switchList("savedAlbumsList");
    this.searchBar.clear().focus();
    return this.header.switchTo("nav");
  };
  AppView.prototype.switchList = function(listName) {
    this.lists.forEach(function(l) {
      return l.hide();
    });
    this.currentList = this[listName];
    this.currentList.show();
    return this.setTabIndex(0);
  };
  return AppView;
})();
_.extend(AppView.prototype, Tabbable, {
  getTabbableElements: function() {
    return this.searchBar.getTabbableElements().concat(this.currentList.getTabbableElements());
  }
});
App = new AppView;