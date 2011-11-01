var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
Views.FriendBrowser = (function() {
  __extends(FriendBrowser, Views.View);
  function FriendBrowser() {
    FriendBrowser.__super__.constructor.apply(this, arguments);
  }
  FriendBrowser.prototype.className = 'friend-browser';
  FriendBrowser.prototype.initialize = function() {
    _.bindAll(this, "loadFriends", "loadFriendsAlbums");
    this.spinner = $('<div class="spinner"/>');
    this.friendList = new UI.FriendList({
      collection: Friends
    });
    this.friendList.bind("select", this.loadFriendsAlbums);
    this.albumList = new UI.FriendsAlbumsList({
      collection: FriendsAlbums
    });
    this.views = [this.spinner, this.friendList, this.albumList];
    this.bind("show", this.loadFriends);
    Friends.bind("refresh", __bind(function() {
      return this.switchView("friendList");
    }, this));
    FriendsAlbums.bind("refresh", __bind(function() {
      return this.switchView("albumList");
    }, this));
    return this.albumList.bind("back", __bind(function() {
      return this.switchView("friendList");
    }, this));
  };
  FriendBrowser.prototype.render = function() {
    var v, _i, _len, _ref;
    $(this.el).append(this.spinner);
    _ref = [this.friendList, this.albumList];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      v = _ref[_i];
      $(this.el).append(v.el);
      v.render();
    }
    return this;
  };
  FriendBrowser.prototype.handleKeypress = function(e) {
    return true;
  };
  FriendBrowser.prototype.loadFriends = function() {
    if (UserInfo && Friends.length === 0) {
      this.switchView("spinner");
      Friends.url = "/friends?auth_token=" + UserInfo.auth_token;
      return Friends.fetch();
    } else {
      return this.switchView("friendList");
    }
  };
  FriendBrowser.prototype.loadFriendsAlbums = function(user) {
    this.albumList.user = user;
    FriendsAlbums.url = user.albumsUrl();
    return FriendsAlbums.fetch();
  };
  return FriendBrowser;
})();
_.extend(Views.FriendBrowser.prototype, Views.Tabbable, {
  getTabbableElements: function() {
    return [this.currentView];
  }
});
Touch.FriendBrowser = (function() {
  __extends(FriendBrowser, Views.FriendBrowser);
  function FriendBrowser() {
    FriendBrowser.__super__.constructor.apply(this, arguments);
  }
  FriendBrowser.prototype.switchView = function(viewName) {
    this.views.forEach(function(v) {
      return $(v.el).children().removeClass('touched');
    });
    return FriendBrowser.__super__.switchView.call(this, viewName);
  };
  return FriendBrowser;
})();