var FriendList;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
FriendList = (function() {
  function FriendList() {
    FriendList.__super__.constructor.apply(this, arguments);
  }
  __extends(FriendList, Backbone.View);
  FriendList.prototype.className = 'friend-list';
  FriendList.prototype.template = _.template('\
    <div class="signed-in" style="display:none">\
      Coming soon!\
    </div>\
\
    <div class="not-signed-in">\
      <a href="/auth/twitter">Connect with Twitter</a>\
      to share your list with your friends.\
    </div>\
  ');
  FriendList.prototype.render = function() {
    $(this.el).html(this.template());
    if (typeof UserInfo != "undefined" && UserInfo !== null) {
      this.$(".signed-in").show();
      this.$(".not-signed-in").hide();
    }
    return this;
  };
  return FriendList;
})();