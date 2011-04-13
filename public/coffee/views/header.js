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
  __extends(Header, View);
  Header.prototype.className = 'header';
  Header.prototype.template = _.template('\
    <div class="sync-controls" style="display:none">\
      <div class="button"/>\
      <div class="spinner" style="display: none"/>\
    </div>\
  ');
  Header.prototype.events = {
    "click .sync-controls .button": "syncClick"
  };
  Header.prototype.render = function() {
    $(this.el).html(this.template());
    if (this.navigation != null) {
      $(this.el).append(this.navigation.render().el);
    }
    return this;
  };
  Header.prototype.syncClick = function(e) {
    return this.trigger("syncButtonClick");
  };
  Header.prototype.addNavigation = function(navigation) {
    this.navigation = navigation;
    return navigation.header = this;
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