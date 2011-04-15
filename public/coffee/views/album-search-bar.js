var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Views.AlbumSearchBar = (function() {
  function AlbumSearchBar() {
    AlbumSearchBar.__super__.constructor.apply(this, arguments);
  }
  __extends(AlbumSearchBar, View);
  AlbumSearchBar.prototype.className = 'album-search-bar';
  AlbumSearchBar.prototype.tagName = 'form';
  AlbumSearchBar.prototype.events = {
    "change input": "handleChange",
    "submit": "handleSubmit"
  };
  AlbumSearchBar.prototype.initialize = function() {
    return _.bindAll(this, "handleKeypress");
  };
  AlbumSearchBar.prototype.render = function() {
    $(this.el).html(this.template());
    return this;
  };
  AlbumSearchBar.prototype.handleKeypress = function(e) {
    if (!this.$("input").is(":focus")) {
      return;
    }
    switch (e.keyCode) {
      case 27:
        e.preventDefault();
        this.clear();
        return this.trigger("clear");
    }
  };
  AlbumSearchBar.prototype.handleChange = function(e) {
    if (this.val() === "") {
      return this.trigger("clear");
    }
  };
  AlbumSearchBar.prototype.handleSubmit = function(e) {
    e.preventDefault();
    if (this.val() === "") {
      this.clear();
      return this.trigger("clear");
    } else {
      return this.trigger("submit", this.val());
    }
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
_.extend(Views.AlbumSearchBar.prototype, Tabbable, {
  getTabbableElements: function() {
    return this.$('input').get();
  }
});
Desktop.AlbumSearchBar = (function() {
  function AlbumSearchBar() {
    AlbumSearchBar.__super__.constructor.apply(this, arguments);
  }
  __extends(AlbumSearchBar, Views.AlbumSearchBar);
  AlbumSearchBar.prototype.template = _.template('\
    <input type="text"/>\
    <button type="submit">Search</button>\
    <div class="spinner" style="display:none"/>\
  ');
  return AlbumSearchBar;
})();
Touch.AlbumSearchBar = (function() {
  function AlbumSearchBar() {
    AlbumSearchBar.__super__.constructor.apply(this, arguments);
  }
  __extends(AlbumSearchBar, Views.AlbumSearchBar);
  AlbumSearchBar.prototype.template = _.template('\
    <div class="inner">\
      <input type="text"/>\
    </div>\
  ');
  AlbumSearchBar.prototype.handleChange = function(e) {
    AlbumSearchBar.__super__.handleChange.call(this, e);
    if (this.val() !== "") {
      return this.trigger("submit", this.val());
    }
  };
  return AlbumSearchBar;
})();