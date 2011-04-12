Mobile = navigator.userAgent.match /iPhone/

loadCSS = (path) ->
  $('head').append("<link rel='stylesheet' type='text/css' href='#{path}?#{CacheBuster}'/>")

if Mobile
  loadCSS('/css/mobile.css')
else
  loadCSS('/css/main.css')

App = new AppView
$(document.body).append(App.render().el)
