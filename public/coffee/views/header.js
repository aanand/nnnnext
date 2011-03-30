var Header;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Header = (function() {
  function Header() {
    Header.__super__.constructor.apply(this, arguments);
  }
  __extends(Header, Backbone.View);
  Header.prototype.className = 'header';
  Header.prototype.template = _.template('\
    <div class="sections">\
      <div class="intro">What are you listening to?</div>\
      <ul class="nav">\
        <li class="current"><a href="/current">Current</a></li>\
        <li class="archived"><a href="/archived">Archived</a></li>\
      </ul>\
    </div>\
\
    <div class="sync-controls">\
      <div class="button"/>\
      <div class="spinner" style="display: none"/>\
    </div>\
  ');
  Header.prototype.events = {
    "click .nav a": "navClick",
    "click .sync-controls .button": "syncClick"
  };
  Header.prototype.render = function() {
    $(this.el).html(this.template()).css({
      position: "relative",
      overflow: "hidden"
    }).find(".sections > *").css({
      position: "absolute",
      top: "0",
      left: "0",
      right: "0"
    }).not("." + this.section).hide();
    if (this.href != null) {
      this.navigate(this.href);
    }
    return this;
  };
  Header.prototype.navClick = function(e) {
    var href;
    e.preventDefault();
    href = $(e.target).attr("href");
    this.navigate(href);
    return this.trigger("navigate", href);
  };
  Header.prototype.syncClick = function(e) {
    return this.trigger("syncButtonClick");
  };
  Header.prototype.navigate = function(href) {
    this.href = href;
    return this.$('.nav a').removeClass('current').filter("[href='" + this.href + "']").addClass('current');
  };
  Header.prototype.switchTo = function(newSection) {
    var height, sections;
    if (newSection === this.section) {
      return;
    }
    height = $(this.el).height();
    sections = this.$(".sections").children();
    sections.filter("." + this.section).animate({
      top: -height
    });
    sections.filter("." + newSection).css({
      top: height
    }).show().animate({
      top: 0
    });
    return this.section = newSection;
  };
  Header.prototype.syncing = function(inProgress) {
    if (inProgress) {
      this.$(".sync-controls .button").hide();
      return this.$(".sync-controls .spinner").show();
    } else {
      this.$(".sync-controls .button").show();
      return this.$(".sync-controls .spinner").hide();
    }
  };
  return Header;
})();