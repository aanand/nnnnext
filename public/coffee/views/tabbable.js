var Tabbable;
Tabbable = {
  setTabIndex: function(n) {
    this.tabIndex = n;
    this.getTabbableElements().forEach(function(e) {
      if (typeof e.setTabIndex === 'function') {
        return n = e.setTabIndex(n);
      } else {
        e.tabIndex = n;
        return n++;
      }
    });
    return n;
  },
  reTab: function() {
    if (this.tabIndex != null) {
      return this.setTabIndex(this.tabIndex);
    }
  },
  getTabbableElements: function() {
    return [this.el];
  }
};