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
require "mongoid"

# lib
require "album_search"

Camping.goes :Nnnnext

module Nnnnext
  def self.root
    @root ||= Pathname.new(File.dirname(__FILE__))
  end

  def self.omniauth
    @omniauth ||= Hash.new { |hsh, key| ENV["OMNIAUTH_#{key.upcase}"] }.tap do |omniauth|
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

  def self.mongoid
    @mongoid ||= Hash.new { |hsh, key| ENV["MONGOID_#{key.upcase}"] }.tap do |mongoid|
      mongoid_file = root + "config/mongoid.yml"

      if File.exist?(mongoid_file)
        mongoid.merge!(YAML.load_file(mongoid_file))
      end
    end
  end

  Mongoid.configure do |config|
    config.from_hash(mongoid)
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
      @headers["content-type"] = "text/html; charset=utf-8"
      render :index
    end
  end

  class AuthTwitterCallback
    def get
      auth = @env['omniauth.auth']

      # require 'pp'; pp auth

      user = User.find_or_create_by(twitter_uid: auth["uid"])
      user.attributes = auth["user_info"]
      user.save!

      @state[:user_id] = user.id

      redirect '/'
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

module Nnnnext::Helpers
  def user_info
    @state[:user_id] && Nnnnext::Models::User.find(@state[:user_id])
  end

  def js_includes
    js = %w(jquery
            json2
            underscore
            backbone/backbone
            Backbone.localStorage/Backbone.localStorage
           ).map { |n| "/js/#{n}.js" }

    js += %w(models/album
             views/tabbable
             views/header
             views/album-view
             views/album-list
             views/album-search-bar
             main
            ).map { |n| "/coffee/#{n}.js" }
  end
end

module Nnnnext::Models
  class User
    include Mongoid::Document
  end
end

