var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
Views.ListManager = (function() {
  __extends(ListManager, Views.View);
  function ListManager() {
    ListManager.__super__.constructor.apply(this, arguments);
  }
  ListManager.prototype.initialize = function() {
    var coll, event, _i, _j, _len, _len2, _ref, _ref2;
    _.bindAll(this, "addAlbum", "startSearch", "finishSearch", "cancelSearch");
    this.albumSearchResults = new AlbumCollection;
    this.searchBar = new UI.AlbumSearchBar({
      collection: this.albumSearchResults,
      listManager: this
    });
    this.searchResultsList = new UI.AlbumSearchList({
      collection: this.albumSearchResults
    });
    this.currentAlbumsList = new UI.SavedAlbumsList({
      collection: CurrentAlbums
    });
    this.archivedAlbumsList = new UI.SavedAlbumsList({
      collection: ArchivedAlbums
    });
    this.views = [this.searchResultsList, this.currentAlbumsList, this.archivedAlbumsList];
    this.searchBar.bind("submit", this.startSearch);
    this.searchBar.bind("clear", this.cancelSearch);
    this.searchResultsList.bind("select", this.addAlbum);
    this.albumSearchResults.bind("refresh", this.finishSearch);
    _ref = [SavedAlbums, this.albumSearchResults];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      coll = _ref[_i];
      _ref2 = ["add", "remove", "refresh"];
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        event = _ref2[_j];
        coll.bind(event, __bind(function() {
          return this.trigger("update");
        }, this));
      }
    }
    return this.bind("show", __bind(function() {
      return this.searchBar.focus();
    }, this));
  };
  ListManager.prototype.isSearching = function() {
    return this.currentView === this.searchResultsList;
  };
  ListManager.prototype.render = function() {
    var v, _i, _len, _ref;
    _ref = [this.searchBar, this.searchResultsList, this.currentAlbumsList, this.archivedAlbumsList];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      v = _ref[_i];
      $(this.el).append(v.el);
      v.render();
    }
    this.currentAlbumsList.populate();
    this.archivedAlbumsList.populate();
    return this;
  };
  ListManager.prototype.setHint = function(hint) {
    return this.currentAlbumsList.setHint(hint);
  };
  ListManager.prototype.handleKeypress = function(e) {
    return this.searchBar.handleKeypress(e);
  };
  ListManager.prototype.switchView = function(name) {
    switch (name) {
      case "current":
      case "archived":
        return ListManager.__super__.switchView.call(this, "" + name + "AlbumsList");
      default:
        return ListManager.__super__.switchView.call(this, name);
    }
  };
  ListManager.prototype.focusSearchBar = function() {
    return this.searchBar.focus();
  };
  ListManager.prototype.startSearch = function(query) {
    if (!query) {
      return;
    }
    this.searchBar.showSpinner();
    this.albumSearchResults.url = "/albums/search?" + $.param({
      q: query
    });
    return this.albumSearchResults.fetch();
  };
  ListManager.prototype.finishSearch = function() {
    this.searchBar.hideSpinner();
    this.searchResultsList.populate();
    return this.switchView("searchResultsList");
  };
  ListManager.prototype.cancelSearch = function() {
    return this.switchView("current");
  };
  ListManager.prototype.addAlbum = function(album) {
    album.addTo(SavedAlbums);
    this.switchView("current");
    this.searchBar.cancel();
    return this.trigger("addAlbum");
  };
  return ListManager;
})();
_.extend(Views.ListManager.prototype, Views.Tabbable, {
  getTabbableElements: function() {
    return [this.searchBar, this.currentView];
  }
});
Desktop.ListManager = (function() {
  __extends(ListManager, Views.ListManager);
  function ListManager() {
    ListManager.__super__.constructor.apply(this, arguments);
  }
  ListManager.prototype.addAlbum = function(album) {
    ListManager.__super__.addAlbum.call(this, album);
    return this.focusSearchBar();
  };
  return ListManager;
})();
Touch.ListManager = (function() {
  __extends(ListManager, Views.ListManager);
  function ListManager() {
    ListManager.__super__.constructor.apply(this, arguments);
  }
  ListManager.prototype.finishSearch = function() {
    ListManager.__super__.finishSearch.call(this);
    console.log("blurring search bar");
    return this.searchBar.blur();
  };
  return ListManager;
})();