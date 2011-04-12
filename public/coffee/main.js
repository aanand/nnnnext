var App, Mobile, loadCSS;
Mobile = navigator.userAgent.match(/iPhone/);
loadCSS = function(path) {
  return $('head').append("<link rel='stylesheet' type='text/css' href='" + path + "?" + CacheBuster + "'/>");
};
if (Mobile) {
  loadCSS('/css/mobile.css');
} else {
  loadCSS('/css/main.css');
}
App = new AppView;
$(document.body).append(App.render().el);