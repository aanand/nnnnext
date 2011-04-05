var FriendList;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
FriendList = (function() {
  function FriendList() {
    FriendList.__super__.constructor.apply(this, arguments);
  }
  __extends(FriendList, View);
  FriendList.prototype.tagName = 'ul';
  FriendList.prototype.className = 'friend-list';
  FriendList.prototype.initialize = function() {
    return this.collection.bind("refresh", __bind(function() {
      return this.populate();
    }, this));
  };
  FriendList.prototype.fetch = function() {
    if (typeof UserInfo != "undefined" && UserInfo !== null) {
      if (!(this.collection.length > 0)) {
        return this.collection.fetch();
      }
    } else {
      return $(this.el).html('\
        <li class="not-signed-in">\
          <a href="/auth/twitter">Connect with Twitter</a>\
          to share your list with your friends.\
        </li>\
      ');
    }
  };
  FriendList.prototype.populate = function() {
    $(this.el).empty();
    return this.collection.models.forEach(__bind(function(user) {
      var view;
      view = new FriendView({
        model: user,
        list: this
      });
      user.view = view;
      return $(this.el).append(view.render().el);
    }, this));
  };
  return FriendList;
})();
_.extend(FriendList.prototype, {
  getTabbableElements: function() {
    return [];
  }
});