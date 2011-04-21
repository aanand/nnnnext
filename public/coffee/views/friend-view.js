var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Views.FriendView = (function() {
  function FriendView() {
    FriendView.__super__.constructor.apply(this, arguments);
  }
  __extends(FriendView, Views.View);
  FriendView.prototype.tagName = 'li';
  FriendView.prototype.className = 'friend';
  FriendView.prototype.template = _.template('\
    <% if (backButton) { %>\
      <div class="back"/>\
    <% } %>\
\
    <img src="<%= image %>"/>\
\
    <div class="info">\
      <div class="name"><%= name %></div>\
      <div class="nickname"><%= nickname %></div>\
    </div>\
  ');
  FriendView.prototype.events = {
    click: "select",
    keypress: "select",
    "click .back": "back"
  };
  FriendView.prototype.initialize = function(options) {
    var _ref;
    this.list = options.list;
    return this.backButton = (_ref = options.backButton) != null ? _ref : false;
  };
  FriendView.prototype.render = function() {
    var vars;
    vars = this.model.toJSON();
    vars.backButton = this.backButton;
    $(this.el).html(this.template(vars));
    return this;
  };
  FriendView.prototype.back = function() {
    return this.trigger("back");
  };
  return FriendView;
})();