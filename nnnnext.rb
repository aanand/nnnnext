require "bundler"
Bundler.setup

require "camping"
require "haml"
require "rack/coffee"
require "sass/plugin/rack"

Camping.goes :Nnnnext

module Nnnnext
  root = Pathname.new(File.dirname(__FILE__))

  set :views, root + "views"

  Sass::Plugin.options[:css_location] = root + "public/css"

  use Rack::Coffee, root: root + "public", urls: ["/coffee"], nowrap: true
  use Sass::Plugin::Rack
  use Rack::Static, root: root + "public", urls: ["/js", "/css", "/img", "/favicon.ico"]
end

module Nnnnext::Controllers
  class Index < R('/')
    def get
      @js =  %w(jquery json2 underscore backbone).map    { |n| "/js/#{n}.js"     }
      @js += %w(models/album views/album-views main).map { |n| "/coffee/#{n}.js" }

      render :index
    end
  end
end
