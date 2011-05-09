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
    keypress: "select"
  };
  AlbumView.prototype.initialize = function(options) {
    return this.list = options.list;
  };
  AlbumView.prototype.ratingTemplate = _.template('\
    <div class="rate">\
      <span data-rating="1"></span><span data-rating="2"></span><span data-rating="3"></span><span data-rating="4"></span><span data-rating="5"></span>\
    </div>\
  ');
  AlbumView.prototype.showRating = false;
  AlbumView.prototype.allowRate = false;
  AlbumView.prototype.templateVars = function() {
    return this.model.toJSON();
  };
  AlbumView.prototype.render = function() {
    var rating, state;
    $(this.el).html(this.template(this.templateVars()));
    rating = this.model.get("rating");
    if (this.showRating && rating > 0) {
      this.appendRatingTo('.info', rating);
    }
    if (this.allowRate) {
      this.appendRatingTo('.controls', rating);
    }
    if (state = this.model.get("state")) {
      $(this.el).attr("data-state", state);
    }
    return this;
  };
  AlbumView.prototype.appendRatingTo = function(selector, rating) {
    var e, stars;
    e = this.$(selector);
    e.append(this.ratingTemplate());
    if (rating != null) {
      stars = e.find(".rate span").get();
      return $(stars.slice(0, rating)).addClass("rated");
    }
  };
  AlbumView.prototype.focus = function(e) {
    return $(this.el).focus();
  };
  return AlbumView;
})();
_.extend(Views.AlbumView.prototype, Views.Tabbable);
Views.SavedAlbumView = (function() {
  function SavedAlbumView() {
    SavedAlbumView.__super__.constructor.apply(this, arguments);
  }
  __extends(SavedAlbumView, Views.AlbumView);
  SavedAlbumView.prototype.template = _.template('\
    <div class="info">\
      <div class="title"><%= title %></div>\
      <div class="artist"><%= artist %></div>\
    </div>\
\
    <div class="controls">\
      <div class="actions">\
        <div class="delete"></div>\
        <% if (state == "archived") { %><div class="restore"></div><% } %>\
        <% if (state == "current")  { %><div class="archive"></div><% } %>\
      </div>\
    </div>\
  ');
  SavedAlbumView.prototype.events = _.extend(_.clone(Views.AlbumView.prototype.events), {
    "mouseover .controls .rate span": "highlightStars",
    "mouseout .controls .rate": "clearStars"
  });
  SavedAlbumView.prototype.initialize = function(options) {
    SavedAlbumView.__super__.initialize.call(this, options);
    return _.bindAll(this, "rate", "archive", "restore", "delete");
  };
  SavedAlbumView.prototype.render = function() {
    SavedAlbumView.__super__.render.call(this);
    this.$(".rate span").tappable(this.rate);
    this.$(".archive").tappable(this.archive);
    this.$(".restore").tappable(this.restore);
    this.$(".delete").tappable(this["delete"]);
    return this;
  };
  SavedAlbumView.prototype.showRating = true;
  SavedAlbumView.prototype.allowRate = true;
  SavedAlbumView.prototype.highlightStars = function(e) {
    this.clearStars();
    $(e.target).prevAll().andSelf().addClass("selected").removeClass("not-selected");
    return $(e.target).nextAll().removeClass("selected").addClass("not-selected");
  };
  SavedAlbumView.prototype.clearStars = function(e) {
    return this.$(".rate span").removeClass("selected").removeClass("not-selected");
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
Touch.SavedAlbumView = (function() {
  function SavedAlbumView() {
    SavedAlbumView.__super__.constructor.apply(this, arguments);
  }
  __extends(SavedAlbumView, Views.SavedAlbumView);
  SavedAlbumView.prototype.initialize = function(options) {
    SavedAlbumView.__super__.initialize.call(this, options);
    _.bindAll(this, "showRateControls");
    return $(this.el).tappable(__bind(function() {
      return this.toggleOpen();
    }, this));
  };
  SavedAlbumView.prototype.render = function(options) {
    var rateButton;
    SavedAlbumView.__super__.render.call(this, options);
    rateButton = $("<div class='show-rate-controls'/>");
    rateButton.tappable(this.showRateControls);
    this.$(".actions").append(rateButton);
    return this;
  };
  SavedAlbumView.prototype.showRateControls = function(e) {
    e.stopPropagation();
    this.open();
    return $(this.el).addClass('showing-rate-controls');
  };
  SavedAlbumView.prototype.hideRateControls = function() {
    return $(this.el).removeClass('showing-rate-controls');
  };
  return SavedAlbumView;
})();
_.extend(Touch.SavedAlbumView.prototype, Views.Openable, {
  onClose: function() {
    return this.hideRateControls();
  }
});
Views.SearchAlbumView = (function() {
  function SearchAlbumView() {
    SearchAlbumView.__super__.constructor.apply(this, arguments);
  }
  __extends(SearchAlbumView, Views.AlbumView);
  SearchAlbumView.prototype.template = _.template('\
    <div class="info">\
      <div class="title"><%= title %></div>\
      <div class="artist"><%= artist %></div>\
    </div>\
  ');
  SearchAlbumView.prototype.events = _.extend(_.clone(Views.AlbumView.prototype.events), {
    click: "select"
  });
  return SearchAlbumView;
})();
Touch.SearchAlbumView = (function() {
  function SearchAlbumView() {
    SearchAlbumView.__super__.constructor.apply(this, arguments);
  }
  __extends(SearchAlbumView, Views.SearchAlbumView);
  SearchAlbumView.prototype.initialize = function(options) {
    SearchAlbumView.__super__.initialize.call(this, options);
    return $(this.el).tappable(__bind(function() {
      return this.select();
    }, this));
  };
  return SearchAlbumView;
})();
Views.FriendsAlbumView = (function() {
  function FriendsAlbumView() {
    FriendsAlbumView.__super__.constructor.apply(this, arguments);
  }
  __extends(FriendsAlbumView, Views.AlbumView);
  FriendsAlbumView.prototype.template = _.template('\
    <div class="info">\
      <div class="title"><%= title %></div>\
      <div class="artist"><%= artist %></div>\
    </div>\
\
    <div class="controls">\
      <div class="actions">\
        <% if (!inMyList) { %><div class="add"/><% } %>\
      </div>\
    </div>\
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