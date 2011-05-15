var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
Views.Links = (function() {
  function Links() {
    Links.__super__.constructor.apply(this, arguments);
  }
  __extends(Links, Views.View);
  Links.prototype.template = _.template('\
    <div class="about">\
      <a href="/about">About</a>\
    </div>\
\
    <% if (signedIn) { %>\
      <div class="signout">\
        <a>Sign out</a>\
      </div>\
    <% } else { %>\
      <div class="signin">\
        <a href="/auth/twitter">Sign in</a>\
      </div>\
    <% } %>\
  ');
  Links.prototype.render = function() {
    $(this.el).html(this.template({
      signedIn: UserInfo
    }));
    this.$('.about a').click(__bind(function(e) {
      e.preventDefault();
      return this.trigger("aboutClick");
    }, this));
    this.$('.signout a').click(__bind(function(e) {
      e.preventDefault();
      return this.trigger("signoutClick");
    }, this));
    return this;
  };
  return Links;
})();
Touch.Links = (function() {
  function Links() {
    Links.__super__.constructor.apply(this, arguments);
  }
  __extends(Links, Views.Links);
  Links.prototype.render = function() {
    Links.__super__.render.call(this);
    this.$('.signin a').sitDownMan();
    return this;
  };
  return Links;
})();