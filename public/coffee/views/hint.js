var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
Views.Hint = (function() {
  __extends(Hint, Views.View);
  function Hint() {
    Hint.__super__.constructor.apply(this, arguments);
  }
  Hint.prototype.className = 'hint';
  Hint.prototype.initialize = function(options) {
    var _ref;
    options = options != null ? options : {};
    return this.dismissButton = (_ref = options.dismissButton) != null ? _ref : true;
  };
  Hint.prototype.events = {
    "click .dismiss": "dismiss"
  };
  Hint.prototype.render = function() {
    $(this.el).empty().append($("<div class='text'/>").html(this.getMessage()));
    if (this.dismissButton) {
      $(this.el).append("<button class='dismiss'/>");
    }
    return this;
  };
  Hint.prototype.remove = function() {
    return $(this.el).remove();
  };
  Hint.prototype.dismiss = function() {
    return $(this.el).fadeOut('fast', __bind(function() {
      this.remove();
      return window.Hint.dismiss(this);
    }, this));
  };
  return Hint;
})();
Views.IntroHint = (function() {
  __extends(IntroHint, Views.Hint);
  function IntroHint() {
    IntroHint.__super__.constructor.apply(this, arguments);
  }
  IntroHint.prototype.getMessage = function() {
    return "    <p><strong>nnnnext</strong> is a todo list for your music.</p>    <p>Use the search bar to find albums you're listening to (or want to listen to) and add them to your list.</p>  ";
  };
  return IntroHint;
})();
Views.FirstAlbumHint = (function() {
  __extends(FirstAlbumHint, Views.Hint);
  function FirstAlbumHint() {
    FirstAlbumHint.__super__.constructor.apply(this, arguments);
  }
  FirstAlbumHint.prototype.getMessage = function() {
    return "    <p>Hover over an album in your list to rate it, check it off or delete it.</p>  ";
  };
  return FirstAlbumHint;
})();
Touch.FirstAlbumHint = (function() {
  __extends(FirstAlbumHint, Views.FirstAlbumHint);
  function FirstAlbumHint() {
    FirstAlbumHint.__super__.constructor.apply(this, arguments);
  }
  FirstAlbumHint.prototype.getMessage = function() {
    return "    <p>Tap an album in your list to rate it, check it off or delete it.</p>  ";
  };
  return FirstAlbumHint;
})();
Views.SignInHint = (function() {
  __extends(SignInHint, Views.Hint);
  function SignInHint() {
    SignInHint.__super__.constructor.apply(this, arguments);
  }
  SignInHint.prototype.getMessage = function() {
    return "    <p>If you <a href='/auth/twitter'>connect with Twitter</a>, you can:</p>        <ul>      <li>sync your list across multiple browsers and devices</li>      <li>share it with your friends</li>      <li>see what they're listening to</li>    </ul>    <p><strong>nnnnext</strong> will never tweet anything on your behalf.</p>  ";
  };
  return SignInHint;
})();
Touch.SignInHint = (function() {
  __extends(SignInHint, Views.SignInHint);
  function SignInHint() {
    SignInHint.__super__.constructor.apply(this, arguments);
  }
  SignInHint.prototype.render = function() {
    SignInHint.__super__.render.call(this);
    this.$('a').sitDownMan();
    return this;
  };
  return SignInHint;
})();
Desktop.AppHint = (function() {
  __extends(AppHint, Views.Hint);
  function AppHint() {
    AppHint.__super__.constructor.apply(this, arguments);
  }
  AppHint.prototype.getMessage = function() {
    return "    <p>      <strong>nnnnext</strong> has a mobile interface too&mdash;visit      <strong>nnnnext.com</strong> on your phone to use it. You can even      install it as an app for quick access.    </p>  ";
  };
  return AppHint;
})();
Touch.AppHint = (function() {
  __extends(AppHint, Views.Hint);
  function AppHint() {
    AppHint.__super__.constructor.apply(this, arguments);
  }
  AppHint.prototype.getMessage = function() {
    var message;
    message = "      <p>        You can install <strong>nnnnext</strong> as stand-alone app for quick        access and a less cluttered interface.      </p>    ";
    if (window.navigator.userAgent.match(/iPhone/)) {
      return message += "        <p>          Tap the middle button at the bottom of your screen and then tap          &ldquo;Add to Home Screen&rdquo;.        </p>      ";
    }
  };
  return AppHint;
})();