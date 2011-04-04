var Banner;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Banner = (function() {
  function Banner() {
    Banner.__super__.constructor.apply(this, arguments);
  }
  __extends(Banner, Backbone.View);
  Banner.prototype.className = 'banner';
  Banner.prototype.template = _.template('\
    <div class="title"/>\
\
    <% if (signedIn) { %>\
      <div class="signout">\
        <a href="/signout"/>\
      </div>\
    <% } else { %>\
      <div class="slogan"/>\
      <div class="signin">\
        <a href="/auth/twitter"/>\
      </div>\
    <% } %>\
  ');
  Banner.prototype.render = function() {
    $(this.el).html(this.template({
      signedIn: typeof UserInfo != "undefined" && UserInfo !== null
    }));
    this.$('.signout a').click(function(e) {
      e.preventDefault();
      return $.get(this.href, function() {
        if (confirm("OK, you're signed out of nnnnext. Sign out of Twitter too?")) {
          return window.location.href = "http://twitter.com/logout";
        } else {
          return window.location.reload();
        }
      });
    });
    return this;
  };
  return Banner;
})();