var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
UI.AppView = (function() {
  function AppView() {
    AppView.__super__.constructor.apply(this, arguments);
  }
  __extends(AppView, View);
  AppView.prototype.el = $('#app');
  AppView.prototype.initialize = function() {
    SavedAlbums.fetch();
    this.banner = new Banner;
    this.header = new Header;
    this.initNavigation();
    this.listManager = new ListManager;
    this.friendBrowser = new FriendBrowser;
    this.views = [this.listManager, this.friendBrowser];
    _.bindAll(this, "navigate", "startSync", "finishSync", "handleKeypress");
    this.navigation.bind("navigate", this.navigate);
    this.header.bind("syncButtonClick", this.startSync);
    this.listManager.bind("addAlbum", __bind(function() {
      return this.navigation.show();
    }, this));
    SavedAlbums.bind("modelSaved", this.startSync);
    Sync.bind("finish", this.finishSync);
    $(window).bind("keydown", this.handleKeypress);
    this.renderSubviews();
    if (SavedAlbums.length === 0 && !(typeof UserInfo != "undefined" && UserInfo !== null)) {
      this.navigation.hide();
    }
    this.tabIndex = 0;
    this.navigate(this.navigation.href);
    return this.startSync();
  };
  AppView.prototype.initNavigation = function() {
    this.navigation = new Navigation;
    return this.navigation.href = "/current";
  };
  AppView.prototype.renderSubviews = function() {
    this.el.append(this.banner.render().el);
    return this.el.append(this.header.render().el);
  };
  AppView.prototype.refreshScroll = function() {};
  AppView.prototype.appendTo = function(parent) {
    return $(parent).append(this.render().el);
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
      return this.navigation.show();
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
_.extend(UI.AppView.prototype, Tabbable, {
  getTabbableElements: function() {
    return [this.currentView];
  }
});
Desktop.AppView = (function() {
  function AppView() {
    AppView.__super__.constructor.apply(this, arguments);
  }
  __extends(AppView, UI.AppView);
  AppView.prototype.initNavigation = function() {
    AppView.__super__.initNavigation.call(this);
    console.log("adding navigation to header");
    return this.header.addNavigation(this.navigation);
  };
  AppView.prototype.renderSubviews = function() {
    AppView.__super__.renderSubviews.call(this);
    console.log("appending subviews directly to @el");
    return this.views.forEach(__bind(function(v) {
      return this.el.append(v.render().el);
    }, this));
  };
  return AppView;
})();
Touch.AppView = (function() {
  function AppView() {
    AppView.__super__.constructor.apply(this, arguments);
  }
  __extends(AppView, UI.AppView);
  AppView.prototype.renderSubviews = function() {
    var scroller;
    AppView.__super__.renderSubviews.call(this);
    console.log("appending navigation directly to @el");
    this.el.append(this.navigation.render().el);
    console.log("appending subviews to #scroller");
    scroller = $("<div id='scroller'/>");
    this.views.forEach(function(v) {
      return scroller.append(v.render().el);
    });
    this.scrollWrapper = $("<div id='scroll-wrapper'/>").append(scroller).appendTo(this.el);
    return this.iScroll = new iScroll(this.scrollWrapper.get(0));
  };
  AppView.prototype.appendTo = function(parent) {
    AppView.__super__.appendTo.call(this, parent);
    return window.setTimeout((__bind(function() {
      return this.refreshScroll();
    }, this)), 1000);
  };
  AppView.prototype.switchView = function(viewName) {
    AppView.__super__.switchView.call(this, viewName);
    return this.refreshScroll();
  };
  AppView.prototype.refreshScroll = function() {
    console.log("refreshing @iScroll");
    return window.setTimeout((__bind(function() {
      return this.iScroll.refresh();
    }, this)), 0);
  };
  return AppView;
})();