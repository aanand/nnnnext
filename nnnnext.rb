require "bundler"
Bundler.setup

$:.unshift("lib")

# stdlib
require "json"

# gems
require "camping"
require "camping/session"
require "haml"
require "rack/coffee"
require "sass/plugin/rack"
require "oa-oauth"

# lib
require "album_search"

Camping.goes :Nnnnext

module Nnnnext
  def self.root
    @root ||= Pathname.new(File.dirname(__FILE__))
  end

  def self.omniauth
    @omniauth ||= Hash.new { |key| ENV["OMNIAUTH_#{key.upcase}"] }.tap do |omniauth|
      omniauth_file = root + "config/omniauth.yml"

      if File.exist?(omniauth_file)
        omniauth.merge!(YAML.load_file(omniauth_file))
      end
    end
  end

  def self.session_secret
    secret_file = root + "config/session_secret.txt"

    if File.exist?(secret_file)
      File.read(secret_file).strip
    else
      ENV["SESSION_SECRET"]
    end
  end

  set :views, root + "views"

  use OmniAuth::Strategies::Twitter,
    omniauth[:consumer_key],
    omniauth[:consumer_secret]

  use Rack::Session::Cookie,
    secret: session_secret

  use Rack::Coffee,
    root:   root + "public",
    urls:   ["/coffee"],
    nowrap: true

  Sass::Plugin.options[:css_location] = root + "public/css"
  use Sass::Plugin::Rack

  use Rack::Static,
    root: root + "public",
    urls: ["/js", "/css", "/img", "/favicon.ico"]
end

module Nnnnext::Controllers
  class Index
    def get
      @js =  %w(jquery json2 underscore backbone).map    { |n| "/js/#{n}.js"     }
      @js += %w(models/album views/album-views main).map { |n| "/coffee/#{n}.js" }

      render :index
    end
  end

  class AuthTwitterCallback
    def get
      @headers["content-type"] = "application/json; charset=utf-8"
      JSON.generate(@env['omniauth.auth'], indent: "  ", object_nl: "\n", array_nl: "\n")
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
