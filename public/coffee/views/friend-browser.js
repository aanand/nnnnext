var FriendBrowser, Friends, FriendsAlbums;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
Friends = new UserCollection;
Friends.url = "/friends";
FriendsAlbums = new AlbumCollection;
FriendBrowser = (function() {
  function FriendBrowser() {
    FriendBrowser.__super__.constructor.apply(this, arguments);
  }
  __extends(FriendBrowser, View);
  FriendBrowser.prototype.initialize = function() {
    _.bindAll(this, "switchToFriend");
    this.friendList = new FriendList({
      collection: Friends
    });
    this.friendList.bind("select", this.switchToFriend);
    this.albumList = new FriendsAlbumsList({
      collection: FriendsAlbums
    });
    this.views = [this.friendList, this.albumList];
    FriendsAlbums.bind("refresh", __bind(function() {
      return this.switchView("albumList");
    }, this));
    return this.bind("show", __bind(function() {
      this.switchView("friendList");
      return this.friendList.fetch();
    }, this));
  };
  FriendBrowser.prototype.render = function() {
    $(this.el).append(this.friendList.render().el);
    $(this.el).append(this.albumList.render().el);
    return this;
  };
  FriendBrowser.prototype.handleKeypress = function(e) {
    return true;
  };
  FriendBrowser.prototype.switchToFriend = function(user) {
    FriendsAlbums.url = user.albumsUrl();
    return FriendsAlbums.fetch();
  };
  return FriendBrowser;
})();
_.extend(FriendBrowser.prototype, Tabbable, {
  getTabbableElements: function() {
    return [this.currentView];
  }
});