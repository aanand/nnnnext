var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Views.Header = (function() {
  __extends(Header, Views.View);
  function Header() {
    Header.__super__.constructor.apply(this, arguments);
  }
  Header.prototype.template = _.template('\
    <div class="navigation"/>\
\
    <div class="sync-controls" style="display:none">\
      <div class="button"/>\
      <div class="spinner" style="display: none"/>\
    </div>\
  ');
  Header.prototype.events = {
    "click .sync-controls .button": "syncClick"
  };
  Header.prototype.initialize = function() {
    return this.navigation = new UI.Navigation;
  };
  Header.prototype.render = function() {
    $(this.el).html(this.template());
    this.navigation.el = this.$(".navigation");
    this.navigation.render();
    return this;
  };
  Header.prototype.syncClick = function(e) {
    return this.trigger("syncButtonClick");
  };
  Header.prototype.syncing = function(inProgress) {
    this.$(".sync-controls").show();
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
Desktop.Header = (function() {
  __extends(Header, Views.Header);
  function Header() {
    Header.__super__.constructor.apply(this, arguments);
  }
  Header.prototype.show = function() {
    return $(this.el).slideDown('fast');
  };
  return Header;
})();