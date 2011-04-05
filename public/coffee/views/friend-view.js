var FriendView;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
FriendView = (function() {
  function FriendView() {
    FriendView.__super__.constructor.apply(this, arguments);
  }
  __extends(FriendView, View);
  FriendView.prototype.tagName = 'li';
  FriendView.prototype.className = 'friend';
  FriendView.prototype.template = _.template('\
    <img src="<%= image %>"/>\
\
    <div class="info">\
      <div class="name"><%= name %></div>\
      <div class="nickname"><%= nickname %></div>\
    </div>\
  ');
  FriendView.prototype.events = {
    mouseover: "highlight",
    mouseout: "highlight",
    focus: "highlight",
    blur: "highlight",
    click: "select",
    keypress: "select"
  };
  FriendView.prototype.initialize = function(options) {
    return this.list = options.list;
  };
  FriendView.prototype.render = function() {
    $(this.el).html(this.template(this.model.toJSON()));
    return this;
  };
  return FriendView;
})();