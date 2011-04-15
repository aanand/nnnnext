var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
Views.AlbumView = (function() {
  function AlbumView() {
    AlbumView.__super__.constructor.apply(this, arguments);
  }
  __extends(AlbumView, Views.View);
  AlbumView.prototype.tagName = 'li';
  AlbumView.prototype.className = 'album';
  AlbumView.prototype.events = {
    keypress: "select",
    mouseover: "showOrHideRating",
    mouseout: "showOrHideRating",
    focus: "highlight",
    blur: "highlight"
  };
  AlbumView.prototype.initialize = function(options) {
    return this.list = options.list;
  };
  AlbumView.prototype.showRating = false;
  AlbumView.prototype.allowRate = false;
  AlbumView.prototype.templateVars = function() {
    return this.model.toJSON();
  };
  AlbumView.prototype.render = function() {
    var rating, stars, state;
    $(this.el).html(this.template(this.templateVars()));
    if (this.showRating) {
      this.$('.controls').append('\
        <div class="rate">\
          <span data-rating="1"></span><span data-rating="2"></span><span data-rating="3"></span><span data-rating="4"></span><span data-rating="5"></span>\
        </div>\
      ');
      rating = this.model.get("rating");
      if (rating != null) {
        stars = this.$(".rate span").get();
        $(stars.slice(0, rating)).addClass("rated");
      }
      this.showOrHideRating();
    }
    if (this.allowRate) {
      $(this.el).addClass("allow-rate");
    }
    if (state = this.model.get("state")) {
      $(this.el).attr("data-state", state);
    }
    return this;
  };
  AlbumView.prototype.showOrHideRating = function(e) {
    if (this.showRating && (this.model.get("rating") || ($(this.el).is(":hover") && this.allowRate))) {
      return this.$('.rate').addClass('visible');
    } else {
      return this.$('.rate').removeClass('visible');
    }
  };
  AlbumView.prototype.focus = function(e) {
    return $(this.el).focus();
  };
  return AlbumView;
})();
_.extend(Views.AlbumView.prototype, Tabbable);
Views.SavedAlbumView = (function() {
  function SavedAlbumView() {
    SavedAlbumView.__super__.constructor.apply(this, arguments);
  }
  __extends(SavedAlbumView, Views.AlbumView);
  SavedAlbumView.prototype.template = _.template('\
    <div class="controls">\
      <div class="delete"></div>\
      <% if (state == "archived") { %><div class="restore"></div><% } %>\
      <% if (state == "current")  { %><div class="archive"></div><% } %>\
    </div>\
\
    <div class="title"><%= title %></div>\
    <div class="artist"><%= artist %></div>\
  ');
  SavedAlbumView.prototype.events = _.extend(_.clone(Views.AlbumView.prototype.events), {
    "mouseover .rate span": "highlightStars",
    "mouseout .rate": "clearStars",
    "click .rate span": "rate",
    "click .archive": "archive",
    "click .restore": "restore",
    "click .delete": "delete"
  });
  SavedAlbumView.prototype.showRating = true;
  SavedAlbumView.prototype.allowRate = true;
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
  SavedAlbumView.prototype.archive = function() {
    return this.model.archive();
  };
  SavedAlbumView.prototype.restore = function() {
    return this.model.restore();
  };
  SavedAlbumView.prototype["delete"] = function() {
    return this.model["delete"]();
  };
  return SavedAlbumView;
})();
Views.SearchAlbumView = (function() {
  function SearchAlbumView() {
    SearchAlbumView.__super__.constructor.apply(this, arguments);
  }
  __extends(SearchAlbumView, Views.AlbumView);
  SearchAlbumView.prototype.template = _.template('\
    <div class="title"><%= title %></div>\
    <div class="artist"><%= artist %></div>\
  ');
  SearchAlbumView.prototype.events = _.extend(_.clone(Views.AlbumView.prototype.events), {
    click: "select",
    mouseover: "highlight",
    mouseout: "highlight"
  });
  return SearchAlbumView;
})();
Views.FriendsAlbumView = (function() {
  function FriendsAlbumView() {
    FriendsAlbumView.__super__.constructor.apply(this, arguments);
  }
  __extends(FriendsAlbumView, Views.AlbumView);
  FriendsAlbumView.prototype.template = _.template('\
    <div class="controls">\
      <div class="add <% if (!inMyList) { %>visible<% } %>"></div>\
    </div>\
\
    <div class="title"><%= title %></div>\
    <div class="artist"><%= artist %></div>\
  ');
  FriendsAlbumView.prototype.templateVars = function() {
    var vars;
    vars = FriendsAlbumView.__super__.templateVars.call(this);
    vars.inMyList = SavedAlbums.any(__bind(function(album) {
      return album.id === this.model.id && album.get("state") === "current";
    }, this));
    return vars;
  };
  FriendsAlbumView.prototype.events = _.extend(_.clone(Views.AlbumView.prototype.events), {
    "click .add": "add"
  });
  FriendsAlbumView.prototype.showRating = true;
  FriendsAlbumView.prototype.add = function(e) {
    var album;
    album = new Album({
      id: this.model.id,
      artist: this.model.get("artist"),
      title: this.model.get("title")
    });
    album.addTo(SavedAlbums);
    return this.$('.add').animate({
      opacity: 0
    });
  };
  return FriendsAlbumView;
})();