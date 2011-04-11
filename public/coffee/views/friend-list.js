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
  FriendList.prototype.populate = function() {
    $(this.el).empty();
    this.collection.models.forEach(__bind(function(user) {
      var view;
      view = new FriendView({
        model: user,
        list: this
      });
      user.view = view;
      return $(this.el).append(view.render().el);
    }, this));
    return this.reTab();
  };
  return FriendList;
})();
_.extend(FriendList.prototype, Tabbable, {
  getTabbableElements: function() {
    return this.collection.models.map(function(m) {
      return m.view.el;
    });
  }
});