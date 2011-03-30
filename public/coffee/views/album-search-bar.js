var AlbumSearchBar;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
AlbumSearchBar = (function() {
  function AlbumSearchBar() {
    AlbumSearchBar.__super__.constructor.apply(this, arguments);
  }
  __extends(AlbumSearchBar, Backbone.View);
  AlbumSearchBar.prototype.template = _.template('\
    <input type="text"/>\
    <div class="spinner" style="display:none"/>\
  ');
  AlbumSearchBar.prototype.events = {
    "change input": "handleChange"
  };
  AlbumSearchBar.prototype.className = 'album-search-bar';
  AlbumSearchBar.prototype.initialize = function() {
    return _.bindAll(this, "handleKeypress");
  };
  AlbumSearchBar.prototype.render = function() {
    $(this.el).html(this.template());
    return this;
  };
  AlbumSearchBar.prototype.handleKeypress = function(e) {
    var val;
    if (!this.$("input").is(":focus")) {
      return;
    }
    switch (e.keyCode) {
      case 13:
        e.preventDefault();
        val = this.$("input").val();
        if (val === "") {
          this.clear();
          return this.trigger("clear");
        } else {
          return this.trigger("submit", val);
        }
        break;
      case 27:
        e.preventDefault();
        this.clear();
        return this.trigger("clear");
    }
  };
  AlbumSearchBar.prototype.handleChange = function(e) {
    if (this.$("input").val() === "") {
      return this.trigger("clear");
    }
  };
  AlbumSearchBar.prototype.clear = function() {
    this.$('input').val('');
    return this;
  };
  AlbumSearchBar.prototype.focus = function() {
    this.$('input').focus();
    return this;
  };
  AlbumSearchBar.prototype.showSpinner = function() {
    return this.$('.spinner').show();
  };
  AlbumSearchBar.prototype.hideSpinner = function() {
    return this.$('.spinner').hide();
  };
  return AlbumSearchBar;
})();
_.extend(AlbumSearchBar.prototype, Tabbable, {
  getTabbableElements: function() {
    return this.$('input').get();
  }
});