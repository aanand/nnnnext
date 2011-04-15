if Mobile
  UI = Touch

  $('head')
    .append('<meta name="apple-mobile-web-app-capable" content="yes">')
    .append('<meta name="viewport" content="width=640,user-scalable=no">')
else
  UI = Desktop

App = new UI.AppView
App.appendTo(document.body)

