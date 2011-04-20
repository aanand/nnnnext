var FilteredCollection;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
FilteredCollection = (function() {
  function FilteredCollection() {
    FilteredCollection.__super__.constructor.apply(this, arguments);
  }
  __extends(FilteredCollection, Backbone.Collection);
  FilteredCollection.prototype.initialize = function(options) {
    _.bindAll(this, "parentAdded", "parentRefreshed", "parentChanged");
    this.parent = options.parent;
    this.filter = options.filter;
    this.comparator = options.comparator;
    this.parent.bind("add", this.parentAdded);
    this.parent.bind("refresh", this.parentRefreshed);
    return this.parent.bind("change", this.parentChanged);
  };
  FilteredCollection.prototype.parentAdded = function(model) {
    if (this.filter(model)) {
      return this.add(model);
    }
  };
  FilteredCollection.prototype.parentRefreshed = function() {
    return this.refresh(this.parent.models.filter(this.filter));
  };
  FilteredCollection.prototype.parentChanged = function(model) {
    var haveModel, shouldHaveModel;
    haveModel = this.models.indexOf(model) !== -1;
    shouldHaveModel = this.filter(model);
    if (haveModel && !shouldHaveModel) {
      return this.remove(model);
    } else if (!haveModel && shouldHaveModel) {
      return this.add(model);
    }
  };
  return FilteredCollection;
})();