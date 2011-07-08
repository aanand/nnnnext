var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
Views.Openable = {
  toggleOpen: function(e) {
    if ($(this.el).hasClass('open')) {
      return this.close();
    } else {
      return this.open();
    }
  },
  open: function() {
    if (!$(this.el).hasClass('open')) {
      $(this.el).addClass('touched').addClass('open');
      window.setTimeout((__bind(function() {
        return $(this.el).removeClass('touched');
      }, this)), 400);
      return this.list.albumOpened(this.model);
    }
  },
  close: function() {
    $(this.el).removeClass('open');
    if (this.onClose != null) {
      return this.onClose.call(this);
    }
  }
};