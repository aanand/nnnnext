var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
Views.AboutPage = (function() {
  function AboutPage() {
    AboutPage.__super__.constructor.apply(this, arguments);
  }
  __extends(AboutPage, Views.View);
  AboutPage.prototype.template = _.template('\
    <h2>About</h2>\
\
    <p>\
      <strong>nnnnext</strong> is a todo list for your music, created to\
      fulfil my specific desires: keep track of everything I think I ought\
      to listen to, play around with some fun client-side technologies and\
      avoid doing anything wholesome with my time.\
    </p>\
\
    <p>\
      My name&rsquo;s <a href="http://www.aanandprasad.com/" target="_blank">Aanand</a>\
      by the way, and I&rsquo;d love to\
      <a href="mailto:aanand.prasad@gmail.com">hear from you</a>.\
    </p>\
\
    <button class="dismiss"/>\
  ');
  AboutPage.prototype.render = function() {
    $(this.el).html(this.template());
    this.$(".dismiss").click(__bind(function(e) {
      e.preventDefault();
      return this.trigger("dismiss");
    }, this));
    return this;
  };
  return AboutPage;
})();