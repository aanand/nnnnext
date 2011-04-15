Mobile = navigator.userAgent.match /iPhone/

loadCSS = (path) ->
  $('head').append("<link rel='stylesheet' type='text/css' href='#{path}?#{CacheBuster}'/>")

if Mobile
  UI = Touch

  loadCSS('/css/mobile.css')

  $('head')
    .append('<meta name="apple-mobile-web-app-capable" content="yes">')
    .append('<meta name="viewport" content="width=640,user-scalable=no">')
else
  UI = Desktop
  loadCSS('/css/main.css')

App = new UI.AppView
App.appendTo(document.body)

