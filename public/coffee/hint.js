var Hint;
Hint = {
  dismiss: function(hint) {
    var hintClass, key;
    if (hintClass = hint.__proto__.constructor.name) {
      key = this.storageKey(hintClass);
      return localStorage.setItem("" + key + "/isDismissed", true);
    }
  },
  isDismissed: function(hintClass) {
    var key;
    key = this.storageKey(hintClass);
    return localStorage.getItem("" + key + "/isDismissed");
  },
  storageKey: function(hintClass) {
    return "" + LocalSync.ns + "/hint/" + hintClass;
  }
};