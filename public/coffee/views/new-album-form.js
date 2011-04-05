var NewAlbumForm;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
NewAlbumForm = (function() {
  function NewAlbumForm() {
    NewAlbumForm.__super__.constructor.apply(this, arguments);
  }
  __extends(NewAlbumForm, View);
  NewAlbumForm.prototype.tagName = 'li';
  NewAlbumForm.prototype.className = 'new-album';
  NewAlbumForm.prototype.events = {
    "submit form": "triggerSubmit"
  };
  NewAlbumForm.prototype.template = _.template('\
    <form action="javascript:void(0);">\
      <label for="artist">\
        <% if (nothingFound) { %>\
          Nothing found in the library. Enter it manually:\
        <% } else { %>\
          Didn’t find what you wanted? Enter it manually:\
        <% } %>\
      </label>\
\
      <input type="text" name="artist" placeholder="Artist"/>\
      <input type="text" name="title"  placeholder="Album Title"/>\
      <button type="submit">Add</button>\
    </form>\
  ');
  NewAlbumForm.prototype.initialize = function(options) {
    return this.nothingFound = options.nothingFound;
  };
  NewAlbumForm.prototype.render = function() {
    $(this.el).html(this.template(this));
    return this;
  };
  NewAlbumForm.prototype.triggerSubmit = function(e) {
    var album, attributes;
    e.preventDefault();
    attributes = _.reduce(this.$('input').serializeArray(), (function(attrs, pair) {
      attrs[pair.name] = pair.value;
      return attrs;
    }), {});
    album = new Album(attributes);
    return this.trigger("submit", album);
  };
  return NewAlbumForm;
})();
_.extend(NewAlbumForm.prototype, Tabbable, {
  getTabbableElements: function() {
    return this.$('input').get();
  }
});