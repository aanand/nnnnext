var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
Views.AlbumList = (function() {
  function AlbumList() {
    AlbumList.__super__.constructor.apply(this, arguments);
  }
  __extends(AlbumList, Views.List);
  AlbumList.prototype.className = 'album-list';
  AlbumList.prototype.makeView = function(album) {
    return album.view = new UI[this.itemViewClassName]({
      model: album,
      list: this
    });
  };
  AlbumList.prototype.albumOpened = function(album) {
    var a, _i, _len, _ref, _results;
    _ref = this.collection.models;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      a = _ref[_i];
      _results.push(a !== album ? a.view.close() : void 0);
    }
    return _results;
  };
  return AlbumList;
})();
Views.SavedAlbumsList = (function() {
  function SavedAlbumsList() {
    SavedAlbumsList.__super__.constructor.apply(this, arguments);
  }
  __extends(SavedAlbumsList, Views.AlbumList);
  SavedAlbumsList.prototype.itemViewClassName = 'SavedAlbumView';
  SavedAlbumsList.prototype.className = "" + Views.AlbumList.prototype.className + " saved-albums-list";
  SavedAlbumsList.prototype.initialize = function(options) {
    SavedAlbumsList.__super__.initialize.call(this, options);
    _.bindAll(this, "add", "remove", "change");
    this.collection.bind("add", this.add);
    this.collection.bind("refresh", this.populate);
    this.collection.bind("remove", this.remove);
    return this.collection.bind("change", this.change);
  };
  SavedAlbumsList.prototype.add = function(album) {
    if ((album.view != null) && album.view.el.parentNode !== this.el) {
      album.removeView();
    }
    this.makeView(album).render();
    return $(this.el).insertAt(album.view.el, this.collection.indexOf(album));
  };
  SavedAlbumsList.prototype.remove = function(album) {
    if ((album.view != null) && album.view.el.parentNode === this.el) {
      return album.removeView();
    }
  };
  SavedAlbumsList.prototype.change = function(album) {
    if (album.view != null) {
      return album.view.render();
    }
  };
  return SavedAlbumsList;
})();
Views.AlbumSearchList = (function() {
  function AlbumSearchList() {
    AlbumSearchList.__super__.constructor.apply(this, arguments);
  }
  __extends(AlbumSearchList, Views.AlbumList);
  AlbumSearchList.prototype.itemViewClassName = 'SearchAlbumView';
  AlbumSearchList.prototype.className = "" + Views.AlbumList.prototype.className + " album-search-list";
  AlbumSearchList.prototype.populate = function() {
    AlbumSearchList.__super__.populate.call(this);
    this.newAlbumForm = new UI.NewAlbumForm({
      nothingFound: this.collection.length === 0
    });
    this.newAlbumForm.bind("submit", __bind(function(model) {
      return this.trigger("select", model);
    }, this));
    return $(this.el).append(this.newAlbumForm.render().el);
  };
  AlbumSearchList.prototype.getTabbableElements = function() {
    return AlbumSearchList.__super__.getTabbableElements.call(this).concat(this.newAlbumForm);
  };
  return AlbumSearchList;
})();
Views.FriendsAlbumsList = (function() {
  function FriendsAlbumsList() {
    FriendsAlbumsList.__super__.constructor.apply(this, arguments);
  }
  __extends(FriendsAlbumsList, Views.AlbumList);
  FriendsAlbumsList.prototype.itemViewClassName = 'FriendsAlbumView';
  FriendsAlbumsList.prototype.className = "" + Views.AlbumList.prototype.className + " friends-albums-list";
  FriendsAlbumsList.prototype.initialize = function(options) {
    FriendsAlbumsList.__super__.initialize.call(this, options);
    return this.collection.bind("refresh", this.populate);
  };
  FriendsAlbumsList.prototype.populate = function() {
    var userView;
    FriendsAlbumsList.__super__.populate.call(this);
    if (this.collection.length === 0) {
      $(this.el).append("<li class='nothing-found'>" + (this.user.get("nickname")) + " doesn’t have any albums queued.</li>");
    }
    if (this.user != null) {
      userView = new UI.FriendView({
        model: this.user,
        highlightable: false,
        backButton: true
      });
      userView.bind("back", __bind(function() {
        return this.trigger("back");
      }, this));
      return $(this.el).prepend(userView.render().el);
    }
  };
  return FriendsAlbumsList;
})();