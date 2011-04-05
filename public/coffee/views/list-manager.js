var ListManager;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
ListManager = (function() {
  function ListManager() {
    ListManager.__super__.constructor.apply(this, arguments);
  }
  __extends(ListManager, View);
  ListManager.prototype.initialize = function() {
    _.bindAll(this, "addAlbum", "startSearch", "finishSearch", "cancelSearch");
    this.albumSearchResults = new AlbumCollection;
    this.searchBar = new AlbumSearchBar({
      collection: this.albumSearchResults
    });
    this.searchResultsList = new AlbumSearchList({
      collection: this.albumSearchResults
    });
    this.savedAlbumsList = new SavedAlbumsList({
      collection: SavedAlbums
    });
    this.views = [this.searchResultsList, this.savedAlbumsList];
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
    $(this.el).append(this.savedAlbumsList.render().el);
    this.savedAlbumsList.populate();
    return this;
  };
  ListManager.prototype.handleKeypress = function(e) {
    return this.searchBar.handleKeypress(e);
  };
  ListManager.prototype.switchView = function(name) {
    switch (name) {
      case "current":
      case "archived":
        ListManager.__super__.switchView.call(this, "savedAlbumsList");
        return this.savedAlbumsList.filter(name);
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
    return this.switchView("savedAlbumsList");
  };
  ListManager.prototype.addAlbum = function(album) {
    album.addTo(SavedAlbums);
    this.switchView("savedAlbumsList");
    this.searchBar.clear().focus();
    return this.header.switchTo("nav");
  };
  return ListManager;
})();
_.extend(ListManager.prototype, Tabbable, {
  getTabbableElements: function() {
    return [this.searchBar, this.currentView];
  }
});