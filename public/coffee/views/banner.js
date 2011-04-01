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
    <div class="slogan"/>\
    <div class="login">\
      <a href="/auth/twitter"/>\
    </div>\
  ');
  Banner.prototype.render = function() {
    $(this.el).html(this.template());
    return this;
  };
  return Banner;
})();