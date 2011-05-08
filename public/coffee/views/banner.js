var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Views.Banner = (function() {
  function Banner() {
    Banner.__super__.constructor.apply(this, arguments);
  }
  __extends(Banner, Views.View);
  Banner.prototype.className = 'banner';
  Banner.prototype.template = _.template('\
    <div class="title"/>\
\
    <% if (signedIn) { %>\
      <div class="signout">\
        <a href="/signout"/>\
      </div>\
    <% } else { %>\
      <div class="signin">\
        <a href="/auth/twitter"/>\
      </div>\
    <% } %>\
  ');
  Banner.prototype.render = function() {
    $(this.el).html(this.template({
      signedIn: typeof UserInfo != "undefined" && UserInfo !== null
    }));
    return this;
  };
  return Banner;
})();
Touch.Banner = (function() {
  function Banner() {
    Banner.__super__.constructor.apply(this, arguments);
  }
  __extends(Banner, Views.Banner);
  Banner.prototype.render = function() {
    Banner.__super__.render.call(this);
    this.$('.signin a').sitDownMan();
    this.$('.signout a').click(function(e) {
      e.preventDefault();
      if (confirm("Are you sure you want to sign out?")) {
        return window.location = this.href;
      }
    });
    return this;
  };
  return Banner;
})();