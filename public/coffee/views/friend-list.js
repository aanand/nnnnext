var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Views.FriendList = (function() {
  function FriendList() {
    FriendList.__super__.constructor.apply(this, arguments);
  }
  __extends(FriendList, Views.List);
  FriendList.prototype.className = 'friend-list';
  FriendList.prototype.initialize = function(options) {
    FriendList.__super__.initialize.call(this, options);
    return this.collection.bind("refresh", this.populate);
  };
  FriendList.prototype.makeView = function(user) {
    return user.view = new UI.FriendView({
      model: user,
      list: this
    });
  };
  FriendList.prototype.render = function() {
    var hint;
    FriendList.__super__.render.call(this);
    if (!UserInfo) {
      hint = new UI.SignInHint({
        dismissButton: false
      });
      this.appendHint(hint);
    }
    return this;
  };
  return FriendList;
})();