var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Views.Navigation = (function() {
  __extends(Navigation, Views.View);
  function Navigation() {
    Navigation.__super__.constructor.apply(this, arguments);
  }
  Navigation.prototype.className = 'navigation';
  Navigation.prototype.template = _.template('\
    <div class="inner">\
      <a class="current" href="/current">Current</a>\
      <a class="archived" href="/archived">Archived</a>\
      <a class="friends" href="/friends">Friends</a>\
    </div>\
  ');
  Navigation.prototype.initialize = function() {
    return _.bindAll(this, "handleClick");
  };
  Navigation.prototype.render = function() {
    $(this.el).html(this.template());
    this.$("a").tappable({
      callback: this.handleClick,
      cancelOnMove: false
    });
    if (this.href != null) {
      this.navigate(this.href);
    }
    return this;
  };
  Navigation.prototype.handleClick = function(e) {
    var href;
    e.preventDefault();
    href = $(e.target).attr("href");
    this.navigate(href);
    return this.trigger("navigate", href);
  };
  Navigation.prototype.navigate = function(href) {
    this.href = href;
    return this.$('a').removeClass('active').filter("[href='" + this.href + "']").addClass('active');
  };
  return Navigation;
})();
Touch.Navigation = (function() {
  __extends(Navigation, Views.Navigation);
  function Navigation() {
    Navigation.__super__.constructor.apply(this, arguments);
  }
  Navigation.prototype.show = function() {
    console.log("setting display: table");
    return $(this.el).css({
      display: "table"
    });
  };
  return Navigation;
})();