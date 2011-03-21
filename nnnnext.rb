require "bundler"
Bundler.setup

$:.unshift("lib")

# stdlib
require "json"

# gems
require "camping"
require "haml"
require "rack/coffee"
require "sass/plugin/rack"

# lib
require "album_search"

Camping.goes :Nnnnext

module Nnnnext
  root = Pathname.new(File.dirname(__FILE__))

  set :views, root + "views"

  use Rack::Coffee,
    root:   root + "public",
    urls:   ["/coffee"],
    nowrap: true

  Sass::Plugin.options[:css_location] = root + "public/css"
  use Sass::Plugin::Rack

  use Rack::Static, root: root + "public", urls: ["/js", "/css", "/img", "/favicon.ico"]
end

module Nnnnext::Controllers
  class Index
    def get
      @js =  %w(jquery json2 underscore backbone).map    { |n| "/js/#{n}.js"     }
      @js += %w(models/album views/album-views main).map { |n| "/coffee/#{n}.js" }

      render :index
    end
  end

  class Albums
    def get
      "[]"
    end
  end

  class AlbumsSearch
    def get
      AlbumSearch.search(@input.q).to_json
    end
  end
end
