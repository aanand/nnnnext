var App, AppView;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
AppView = (function() {
  function AppView() {
    AppView.__super__.constructor.apply(this, arguments);
  }
  __extends(AppView, View);
  AppView.prototype.el = $('#app');
  AppView.prototype.initialize = function() {
    SavedAlbums.fetch();
    this.banner = new Banner;
    this.header = new Header;
    this.header.href = "/current";
    if (SavedAlbums.length > 0) {
      this.header.section = "nav";
    } else {
      this.header.section = "intro";
    }
    this.listManager = new ListManager;
    this.friendBrowser = new FriendBrowser;
    this.views = [this.listManager, this.friendBrowser];
    _.bindAll(this, "navigate", "startSync", "finishSync", "handleKeypress");
    this.header.bind("navigate", this.navigate);
    this.header.bind("syncButtonClick", this.startSync);
    this.listManager.bind("addAlbum", __bind(function() {
      return this.header.switchTo("nav");
    }, this));
    SavedAlbums.bind("modelSaved", this.startSync);
    Sync.bind("finish", this.finishSync);
    $(window).bind("keydown", this.handleKeypress);
    this.el.append(this.banner.render().el);
    this.el.append(this.header.render().el);
    this.el.append(this.listManager.render().el);
    this.el.append(this.friendBrowser.render().el);
    this.tabIndex = 0;
    this.navigate("/current");
    return this.startSync();
  };
  AppView.prototype.startSync = function() {
    if (typeof UserInfo == "undefined" || UserInfo === null) {
      return;
    }
    this.header.syncing(true);
    return Sync.start(SavedAlbums, "/albums/sync");
  };
  AppView.prototype.finishSync = function() {
    window.setTimeout((__bind(function() {
      return this.header.syncing(false);
    }, this)), 500);
    if (SavedAlbums.length > 0) {
      return this.header.switchTo("nav");
    }
  };
  AppView.prototype.navigate = function(href) {
    switch (href) {
      case "/current":
        this.listManager.switchView("current");
        return this.switchView("listManager");
      case "/archived":
        this.listManager.switchView("archived");
        return this.switchView("listManager");
      case "/friends":
        return this.switchView("friendBrowser");
    }
  };
  AppView.prototype.handleKeypress = function(e) {
    switch (e.keyCode) {
      case 38:
        e.preventDefault();
        return this.tab(-1);
      case 40:
        e.preventDefault();
        return this.tab(+1);
      default:
        return this.currentView.handleKeypress(e);
    }
  };
  AppView.prototype.tab = function(offset) {
    var currentIndex, elements, focus, nextIndex;
    elements = _.sortBy($(":visible[tabindex]").get(), function(e) {
      return e.tabIndex;
    });
    focus = $(':focus').filter(":visible")[0];
    nextIndex = null;
    if (focus != null) {
      currentIndex = _.indexOf(elements.map(function(e) {
        return e.tabIndex;
      }), focus.tabIndex);
      nextIndex = (currentIndex + offset + elements.length) % elements.length;
    } else {
      nextIndex = 0;
    }
    if (focus != null) {
      $(focus).blur();
    }
    return $(elements[nextIndex]).focus();
  };
  return AppView;
})();
_.extend(AppView.prototype, Tabbable, {
  getTabbableElements: function() {
    return [this.currentView];
  }
});
App = new AppView;