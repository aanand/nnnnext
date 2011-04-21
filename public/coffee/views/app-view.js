var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
Views.AppView = (function() {
  function AppView() {
    AppView.__super__.constructor.apply(this, arguments);
  }
  __extends(AppView, Views.View);
  AppView.prototype.el = $('#app');
  AppView.prototype.initialize = function() {
    var v, _i, _len, _ref;
    SavedAlbums.fetch();
    this.banner = new UI.Banner;
    this.header = new UI.Header;
    this.initNavigation();
    this.listManager = new UI.ListManager;
    this.friendBrowser = new UI.FriendBrowser;
    this.views = [this.listManager, this.friendBrowser];
    _.bindAll(this, "navigate", "startSync", "finishSync", "handleKeypress", "showNavigation", "setHint", "refreshScroll");
    this.navigation.bind("navigate", this.navigate);
    this.header.bind("syncButtonClick", this.startSync);
    this.listManager.bind("addAlbum", this.showNavigation);
    LocalSync.bind("sync", this.startSync);
    Sync.bind("finish", this.finishSync);
    CurrentAlbums.bind("add", this.setHint);
    CurrentAlbums.bind("remove", this.setHint);
    $(window).bind("keydown", this.handleKeypress);
    _ref = this.views;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      v = _ref[_i];
      v.bind("update", this.refreshScroll);
    }
    this.renderSubviews();
    if (this.isNewUser()) {
      this.hideNavigation();
    }
    this.tabIndex = 0;
    this.navigate(this.navigation.href);
    return this.startSync();
  };
  AppView.prototype.initNavigation = function() {
    this.navigation = new UI.Navigation;
    return this.navigation.href = "/current";
  };
  AppView.prototype.hideNavigation = function() {
    return this.navigation.hide();
  };
  AppView.prototype.showNavigation = function() {
    return this.navigation.show();
  };
  AppView.prototype.renderSubviews = function() {
    this.el.append(this.banner.render().el);
    return this.el.append(this.header.render().el);
  };
  AppView.prototype.refreshScroll = function() {};
  AppView.prototype.appendTo = function(parent) {
    $(parent).append(this.render().el);
    return this.setHint();
  };
  AppView.prototype.startSync = function() {
    if (typeof UserInfo == "undefined" || UserInfo === null) {
      return;
    }
    this.header.syncing(true);
    return Sync.start(SavedAlbums, "/albums/sync");
  };
  AppView.prototype.finishSync = function() {
    return window.setTimeout((__bind(function() {
      return this.header.syncing(false);
    }, this)), 500);
  };
  AppView.prototype.navigate = function(href) {
    switch (href) {
      case "/current":
        this.listManager.switchView("current");
        this.switchView("listManager");
        break;
      case "/archived":
        this.listManager.switchView("archived");
        this.switchView("listManager");
        break;
      case "/friends":
        this.switchView("friendBrowser");
    }
    return this.setHint();
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
  AppView.prototype.setHint = function() {
    var hint, hintClass;
    hintClass = typeof UserInfo != "undefined" && UserInfo !== null ? null : this.isNewUser() ? hintClass = 'IntroHint' : this.hasOneAlbum() ? hintClass = 'FirstAlbumHint' : hintClass = 'SignInHint';
    hint = hintClass != null ? Hint.isDismissed(hintClass) ? null : new UI[hintClass] : void 0;
    return this.listManager.setHint(hint);
  };
  AppView.prototype.isNewUser = function() {
    return SavedAlbums.length === 0 && !(typeof UserInfo != "undefined" && UserInfo !== null);
  };
  AppView.prototype.hasOneAlbum = function() {
    return SavedAlbums.length === 1 && SavedAlbums.models[0].get("state") === "current";
  };
  return AppView;
})();
_.extend(Views.AppView.prototype, Views.Tabbable, {
  getTabbableElements: function() {
    return [this.currentView];
  }
});
Desktop.AppView = (function() {
  function AppView() {
    AppView.__super__.constructor.apply(this, arguments);
  }
  __extends(AppView, Views.AppView);
  AppView.prototype.initNavigation = function() {
    AppView.__super__.initNavigation.call(this);
    return this.header.addNavigation(this.navigation);
  };
  AppView.prototype.hideNavigation = function() {
    return this.header.hide();
  };
  AppView.prototype.showNavigation = function() {
    return this.header.show();
  };
  AppView.prototype.renderSubviews = function() {
    AppView.__super__.renderSubviews.call(this);
    return this.views.forEach(__bind(function(v) {
      return this.el.append(v.render().el);
    }, this));
  };
  AppView.prototype.appendTo = function(parent) {
    AppView.__super__.appendTo.call(this, parent);
    return this.listManager.focusSearchBar();
  };
  return AppView;
})();
Touch.AppView = (function() {
  function AppView() {
    AppView.__super__.constructor.apply(this, arguments);
  }
  __extends(AppView, Views.AppView);
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