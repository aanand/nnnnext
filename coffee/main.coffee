Mobile = navigator.userAgent.match /iPhone/

loadCSS = (path) ->
  $('head').append("<link rel='stylesheet' type='text/css' href='#{path}?#{CacheBuster}'/>")

if Mobile
  Views = Touch

  loadCSS('/css/mobile.css')

  $('head')
    .append('<meta name="apple-mobile-web-app-capable" content="yes">')
    .append('<meta name="viewport" content="width=640,user-scalable=no">')
else
  Views = Desktop
  loadCSS('/css/main.css')

App = new Views.AppView
App.appendTo(document.body)

