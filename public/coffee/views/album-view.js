var AlbumView, SavedAlbumView, SearchAlbumView;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
AlbumView = (function() {
  function AlbumView() {
    AlbumView.__super__.constructor.apply(this, arguments);
  }
  __extends(AlbumView, Backbone.View);
  AlbumView.prototype.tagName = 'li';
  AlbumView.prototype.events = {
    "keypress": "handleKeypress"
  };
  AlbumView.prototype.initialize = function(options) {
    return this.list = options.list;
  };
  AlbumView.prototype.render = function() {
    $(this.el).html(this.template(this.model.toJSON()));
    return this;
  };
  AlbumView.prototype.handleKeypress = function(e) {
    if (e.keyCode !== 13) {
      return;
    }
    e.preventDefault();
    return this.select();
  };
  AlbumView.prototype.focus = function(e) {
    return $(this.el).focus();
  };
  AlbumView.prototype.select = function() {
    if (this.list != null) {
      return this.list.trigger("select", this.model);
    }
  };
  return AlbumView;
})();
_.extend(AlbumView.prototype, Tabbable);
SavedAlbumView = (function() {
  function SavedAlbumView() {
    SavedAlbumView.__super__.constructor.apply(this, arguments);
  }
  __extends(SavedAlbumView, AlbumView);
  SavedAlbumView.prototype.template = _.template('\
    <div class="rate">\
      <span data-rating="1"></span><span data-rating="2"></span><span data-rating="3"></span><span data-rating="4"></span><span data-rating="5"></span>\
    </div>\
    <div class="delete"></div>\
    <div class="title"><%= title %></div>\
    <div class="artist"><%= artist %></div>\
  ');
  SavedAlbumView.prototype.events = _.extend(_.clone(AlbumView.prototype.events), {
    "mouseover .rate span": "highlightStars",
    "mouseout .rate": "clearStars",
    "click .rate span": "rate",
    "click .delete": "delete"
  });
  SavedAlbumView.prototype.render = function() {
    var rating, stars;
    SavedAlbumView.__super__.render.call(this);
    rating = this.model.get("rating");
    if (rating != null) {
      stars = this.$(".rate span").get();
      $(this.el).addClass("has-rating");
      $(stars.slice(0, rating)).addClass("rated");
    }
    return this;
  };
  SavedAlbumView.prototype.highlightStars = function(e) {
    this.clearStars();
    return $(e.target).prevAll().andSelf().addClass("selected");
  };
  SavedAlbumView.prototype.clearStars = function(e) {
    return this.$(".rate span").removeClass("selected");
  };
  SavedAlbumView.prototype.rate = function(e) {
    return this.model.rate(parseInt($(e.target).attr('data-rating')));
  };
  SavedAlbumView.prototype["delete"] = function() {
    return this.model["delete"]();
  };
  SavedAlbumView.prototype.show = function() {
    return $(this.el).show();
  };
  SavedAlbumView.prototype.hide = function() {
    return $(this.el).hide();
  };
  return SavedAlbumView;
})();
SearchAlbumView = (function() {
  function SearchAlbumView() {
    SearchAlbumView.__super__.constructor.apply(this, arguments);
  }
  __extends(SearchAlbumView, AlbumView);
  SearchAlbumView.prototype.template = _.template('\
    <div class="title"><%= title %></div>\
    <div class="artist"><%= artist %></div>\
  ');
  SearchAlbumView.prototype.events = _.extend(_.clone(AlbumView.prototype.events), {
    "click": "select"
  });
  return SearchAlbumView;
})();