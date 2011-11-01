var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
Views.FriendView = (function() {
  __extends(FriendView, Views.View);
  function FriendView() {
    FriendView.__super__.constructor.apply(this, arguments);
  }
  FriendView.prototype.tagName = 'li';
  FriendView.prototype.className = 'friend';
  FriendView.prototype.template = _.template('\
    <% if (backButton) { %>\
      <div class="back"/>\
    <% } %>\
\
    <div class="info">\
      <img src="<%= image %>"/>\
\
      <div class="name"><%= name %></div>\
      <div class="nickname"><%= nickname %></div>\
    </div>\
  ');
  FriendView.prototype.events = {
    keypress: "select",
    "click .back": "back"
  };
  FriendView.prototype.initialize = function(options) {
    var _ref;
    this.list = options.list;
    return this.backButton = (_ref = options.backButton) != null ? _ref : false;
  };
  FriendView.prototype.render = function() {
    var callback, vars;
    vars = this.model.toJSON();
    vars.backButton = this.backButton;
    $(this.el).html(this.template(vars));
    callback = __bind(function() {
      $(this.el).addClass('touched');
      return this.select();
    }, this);
    $(this.el).tappable({
      callback: callback,
      touchDelay: TouchDelay
    });
    return this;
  };
  FriendView.prototype.back = function() {
    return this.trigger("back");
  };
  return FriendView;
})();