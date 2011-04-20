var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
Views.ListManager = (function() {
  function ListManager() {
    ListManager.__super__.constructor.apply(this, arguments);
  }
  __extends(ListManager, Views.View);
  ListManager.prototype.initialize = function() {
    _.bindAll(this, "addAlbum", "startSearch", "finishSearch", "cancelSearch");
    this.albumSearchResults = new AlbumCollection;
    this.searchBar = new UI.AlbumSearchBar({
      collection: this.albumSearchResults
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
    return this.bind("show", __bind(function() {
      return this.searchBar.focus();
    }, this));
  };
  ListManager.prototype.render = function() {
    $(this.el).append(this.searchBar.render().el);
    $(this.el).append(this.searchResultsList.render().el);
    $(this.el).append(this.currentAlbumsList.render().el);
    $(this.el).append(this.archivedAlbumsList.render().el);
    this.currentAlbumsList.populate();
    this.archivedAlbumsList.populate();
    return this;
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
    this.searchBar.clear();
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
  function ListManager() {
    ListManager.__super__.constructor.apply(this, arguments);
  }
  __extends(ListManager, Views.ListManager);
  ListManager.prototype.addAlbum = function(album) {
    ListManager.__super__.addAlbum.call(this, album);
    console.log("focusing search bar");
    return this.searchBar.focus();
  };
  return ListManager;
})();
Touch.ListManager = (function() {
  function ListManager() {
    ListManager.__super__.constructor.apply(this, arguments);
  }
  __extends(ListManager, Views.ListManager);
  ListManager.prototype.finishSearch = function() {
    ListManager.__super__.finishSearch.call(this);
    console.log("blurring search bar");
    return this.searchBar.blur();
  };
  return ListManager;
})();