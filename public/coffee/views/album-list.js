var AlbumList, AlbumSearchList, FriendsAlbumsList, SavedAlbumsList;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
AlbumList = (function() {
  function AlbumList() {
    AlbumList.__super__.constructor.apply(this, arguments);
  }
  __extends(AlbumList, View);
  AlbumList.prototype.tagName = 'ul';
  AlbumList.prototype.className = 'album-list';
  AlbumList.prototype.initialize = function(options) {
    return _.bindAll(this, "populate");
  };
  AlbumList.prototype.populate = function() {
    $(this.el).empty();
    return this.collection.forEach(__bind(function(album) {
      return $(this.el).append(this.makeView(album).render().el);
    }, this));
  };
  AlbumList.prototype.makeView = function(album) {
    return album.view = new this.itemViewClass({
      model: album,
      list: this
    });
  };
  return AlbumList;
})();
_.extend(AlbumList.prototype, Tabbable, {
  getTabbableElements: function() {
    return this.collection.map(function(album) {
      return album.view.el;
    });
  }
});
SavedAlbumsList = (function() {
  function SavedAlbumsList() {
    SavedAlbumsList.__super__.constructor.apply(this, arguments);
  }
  __extends(SavedAlbumsList, AlbumList);
  SavedAlbumsList.prototype.itemViewClass = SavedAlbumView;
  SavedAlbumsList.prototype.className = "" + AlbumList.prototype.className + " saved-albums-list";
  SavedAlbumsList.prototype.initialize = function(options) {
    SavedAlbumsList.__super__.initialize.call(this, options);
    _.bindAll(this, "makeView", "modelSaved");
    this.collection.bind("add", this.makeView);
    this.collection.bind("modelSaved", this.modelSaved);
    return this.collection.bind("modelDestroyed", this.modelDestroyed);
  };
  SavedAlbumsList.prototype.filter = function(state) {
    this.filterState = state;
    return this.collection.forEach(__bind(function(album) {
      return this.showOrHideView(album);
    }, this));
  };
  SavedAlbumsList.prototype.showOrHideView = function(album) {
    if (this.filterState == null) {
      return;
    }
    if (album.get("state") === this.filterState) {
      return album.view.show();
    } else {
      return album.view.hide();
    }
  };
  SavedAlbumsList.prototype.modelSaved = function(album) {
    var albumEl, childToInsertBefore, correctIndex, currentIndex;
    album.view.render();
    this.showOrHideView(album);
    albumEl = album.view.el;
    correctIndex = this.collection.indexOf(album);
    currentIndex = $(this.el).children().get().indexOf(albumEl);
    if (currentIndex !== correctIndex) {
      if (currentIndex !== -1) {
        this.el.removeChild(albumEl);
      }
      childToInsertBefore = $(this.el).children()[correctIndex];
      if (childToInsertBefore != null) {
        return $(albumEl).insertBefore(childToInsertBefore);
      } else {
        return $(albumEl).appendTo(this.el);
      }
    }
  };
  SavedAlbumsList.prototype.modelDestroyed = function(album) {
    if (album.view != null) {
      return album.view.remove();
    }
  };
  return SavedAlbumsList;
})();
AlbumSearchList = (function() {
  function AlbumSearchList() {
    AlbumSearchList.__super__.constructor.apply(this, arguments);
  }
  __extends(AlbumSearchList, AlbumList);
  AlbumSearchList.prototype.itemViewClass = SearchAlbumView;
  AlbumSearchList.prototype.className = "" + AlbumList.prototype.className + " album-search-list";
  AlbumSearchList.prototype.populate = function() {
    AlbumSearchList.__super__.populate.call(this);
    this.newAlbumForm = new NewAlbumForm({
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
FriendsAlbumsList = (function() {
  function FriendsAlbumsList() {
    FriendsAlbumsList.__super__.constructor.apply(this, arguments);
  }
  __extends(FriendsAlbumsList, AlbumList);
  FriendsAlbumsList.prototype.itemViewClass = FriendsAlbumView;
  FriendsAlbumsList.prototype.className = "" + AlbumList.prototype.className + " friends-albums-list";
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
      userView = new FriendView({
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