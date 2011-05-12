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
    SavedAlbums.fetch();
    $(this.el).html(this.template());
    if (this.isNewUser()) {
      this.hideHeader();
    }
    this.hideAboutPage();
    this.links = new UI.Links({
      el: this.$(".links")
    });
    this.header = new UI.Header({
      el: this.$(".header")
    });
    this.aboutPage = new UI.AboutPage({
      el: this.$(".about-page")
    });
    this.navigation = this.header.navigation;
    this.navigation.href = "/current";
    this.listManager = new UI.ListManager;
    this.friendBrowser = new UI.FriendBrowser;
    this.views = [this.listManager, this.friendBrowser];
    this.links.render();
    this.header.render();
    this.aboutPage.render();
    this.views.forEach(__bind(function(v) {
      return this.$(".views").append(v.render().el);
    }, this));
    _.bindAll(this, "navigate", "showAboutPage", "hideAboutPage", "startSync", "finishSync", "handleKeypress", "showHeader", "setHint");
    this.navigation.bind("navigate", this.navigate);
    this.links.bind("aboutClick", this.showAboutPage);
    this.aboutPage.bind("dismiss", this.hideAboutPage);
    this.header.bind("syncButtonClick", this.startSync);
    this.listManager.bind("addAlbum", this.showHeader);
    LocalSync.bind("sync", this.startSync);
    Sync.bind("finish", this.finishSync);
    CurrentAlbums.bind("add", this.setHint);
    CurrentAlbums.bind("remove", this.setHint);
    $(window).bind("keydown", this.handleKeypress);
    this.tabIndex = 0;
    this.navigate(this.navigation.href);
    this.startSync();
    return this.setHint();
  };
  AppView.prototype.hideHeader = function() {
    return this.$(".header").hide();
  };
  AppView.prototype.showHeader = function() {
    return this.$(".header").show();
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
  AppView.prototype.showAboutPage = function() {
    this.$(".ui").hide();
    return this.$(".about-page").show();
  };
  AppView.prototype.hideAboutPage = function() {
    this.$(".about-page").hide();
    return this.$(".ui").show();
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
    hintClass = typeof UserInfo != "undefined" && UserInfo !== null ? window.navigator.standalone ? null : 'AppHint' : this.isNewUser() ? 'IntroHint' : this.hasOneAlbum() ? 'FirstAlbumHint' : 'SignInHint';
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
  AppView.prototype.template = _.template('\
    <div class="banner">\
      <div class="title"/>\
      <div class="links"/>\
    </div>\
\
    <div class="main">\
      <div class="about-page"/>\
      <div class="ui">\
        <div class="header"/>\
        <div class="views"/>\
      </div>\
    </div>\
  ');
  AppView.prototype.initialize = function(options) {
    AppView.__super__.initialize.call(this, options);
    return this.listManager.focusSearchBar();
  };
  return AppView;
})();
Touch.AppView = (function() {
  function AppView() {
    AppView.__super__.constructor.apply(this, arguments);
  }
  __extends(AppView, Views.AppView);
  AppView.prototype.template = _.template('\
    <div class="main">\
      <div class="banner">\
        <div class="title"/>\
      </div>\
\
      <div class="ui">\
        <div class="header"/>\
        <div class="views"/>\
      </div>\
\
      <div class="about-page"/>\
\
      <div class="links"/>\
    </div>\
  ');
  AppView.prototype.initialize = function(options) {
    var bannerHeight, linksHeight, minHeight, viewportHeight;
    AppView.__super__.initialize.call(this, options);
    bannerHeight = this.$(".banner").outerHeight();
    linksHeight = this.$(".links").outerHeight();
    viewportHeight = $(window).height();
    minHeight = viewportHeight - bannerHeight - linksHeight;
    return this.$(".ui, .about-page").css({
      minHeight: "" + minHeight + "px"
    });
  };
  return AppView;
})();