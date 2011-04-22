var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
Views.AlbumSearchBar = (function() {
  function AlbumSearchBar() {
    AlbumSearchBar.__super__.constructor.apply(this, arguments);
  }
  __extends(AlbumSearchBar, Views.View);
  AlbumSearchBar.prototype.className = 'album-search-bar';
  AlbumSearchBar.prototype.tagName = 'form';
  AlbumSearchBar.prototype.template = _.template('\
    <input type="text"/>\
    <button type="submit">Search</button>\
    <div class="spinner" style="display:none"/>\
    <div class="cancel" style="display:none"/>\
  ');
  AlbumSearchBar.prototype.events = {
    submit: "handleSubmit"
  };
  AlbumSearchBar.prototype.initialize = function(options) {
    _.bindAll(this, "handleKeypress", "cancel");
    return this.listManager = options.listManager;
  };
  AlbumSearchBar.prototype.render = function() {
    $(this.el).html(this.template());
    this.$(".cancel").tappable(this.cancel);
    return this;
  };
  AlbumSearchBar.prototype.handleKeypress = function(e) {
    window.setTimeout((__bind(function() {
      return this.showOrHideCancel();
    }, this)), 0);
    if (!this.$("input").is(":focus")) {
      return;
    }
    switch (e.keyCode) {
      case 27:
        e.preventDefault();
        return this.cancel();
    }
  };
  AlbumSearchBar.prototype.handleSubmit = function(e) {
    e.preventDefault();
    if (this.val() === "") {
      return this.cancel();
    } else {
      return this.trigger("submit", this.val());
    }
  };
  AlbumSearchBar.prototype.showOrHideCancel = function() {
    if (this.val() !== "" || this.listManager.isSearching()) {
      return this.$(".cancel").show();
    } else {
      return this.$(".cancel").hide();
    }
  };
  AlbumSearchBar.prototype.cancel = function(e) {
    if (e) {
      e.preventDefault();
    }
    this.clear();
    this.focus();
    this.trigger("clear");
    return this.showOrHideCancel();
  };
  AlbumSearchBar.prototype.val = function() {
    return this.$("input").val();
  };
  AlbumSearchBar.prototype.clear = function() {
    this.$('input').val('');
    return this;
  };
  AlbumSearchBar.prototype.focus = function() {
    this.$('input').focus();
    return this;
  };
  AlbumSearchBar.prototype.blur = function() {
    this.$('input').blur();
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
_.extend(Views.AlbumSearchBar.prototype, Views.Tabbable, {
  getTabbableElements: function() {
    return this.$('input').get();
  }
});