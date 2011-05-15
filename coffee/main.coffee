if Platform == "mobile"
  UI = Touch

  $('head')
    .append('<meta name="apple-mobile-web-app-capable" content="yes">')
    .append('<meta name="viewport" content="width=device-width,user-scalable=no">')
    .append('<link rel="apple-touch-startup-image" href="/img/startup.png">')
    .append('<link rel="apple-touch-icon" href="/img/icon.png">')
else
  UI = Desktop

App = new UI.AppView

