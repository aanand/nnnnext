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
      $(this.el).addClass('open');
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