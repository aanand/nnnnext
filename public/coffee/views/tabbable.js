var Tabbable;
Tabbable = {
  setTabIndex: function(n) {
    return this.getTabbableElements().forEach(function(e) {
      if (typeof e.setTabIndex === 'function') {
        n = e.setTabIndex(n);
      } else {
        e.tabIndex = n;
        n++;
      }
      return n;
    });
  },
  getTabbableElements: function() {
    return [this.el];
  }
};