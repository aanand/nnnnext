var AlbumList, AlbumSearchList, SavedAlbumsList;
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
  __extends(AlbumList, Backbone.View);
  AlbumList.prototype.tagName = 'ul';
  AlbumList.prototype.className = 'album-list';
  AlbumList.prototype.populate = function() {
    $(this.el).empty();
    return this.collection.forEach(__bind(function(album) {
      return $(this.el).append(this.makeView(album).el);
    }, this));
  };
  AlbumList.prototype.makeView = function(album) {
    return album.view = new this.itemViewClass({
      model: album,
      list: this
    }).render();
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
    _.bindAll(this, "makeView", "modelSaved");
    this.collection.bind("add", this.makeView);
    return this.collection.bind("modelSaved", this.modelSaved);
  };
  SavedAlbumsList.prototype.makeView = function(album) {
    var view;
    view = SavedAlbumsList.__super__.makeView.call(this, album);
    this.showOrHideView(album);
    return view;
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
    if (this.collection.length === 0) {
      return $(this.el).html('<li class="nothing-found">Nothing found.</li>');
    }
  };
  return AlbumSearchList;
})();