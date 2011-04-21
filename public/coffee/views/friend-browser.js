var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
Views.FriendBrowser = (function() {
  function FriendBrowser() {
    FriendBrowser.__super__.constructor.apply(this, arguments);
  }
  __extends(FriendBrowser, Views.View);
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
    $(this.el).append(this.spinner);
    $(this.el).append(this.friendList.render().el);
    $(this.el).append(this.albumList.render().el);
    return this;
  };
  FriendBrowser.prototype.handleKeypress = function(e) {
    return true;
  };
  FriendBrowser.prototype.loadFriends = function() {
    if ((typeof UserInfo != "undefined" && UserInfo !== null) && Friends.length === 0) {
      this.switchView("spinner");
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