require "bundler"
Bundler.setup

$:.unshift("lib")

# stdlib
require "json"
require "uri"

# gems
require "camping"
require "camping/session"
require "haml"
require "sass/plugin/rack"
require "oa-oauth"
require "mongoid"

# lib
require "album_search"
require "daemon"

Mongoid.configure do |config|
  mongoid_file = File.expand_path("../config/mongoid.yml", __FILE__)

  if File.exist?(mongoid_file)
    mc = YAML.load_file(mongoid_file)
    config.from_hash(mc)
    config.logger = Logger.new(mc["log_file"]) if mc.has_key?("log_file")
  end

  if ENV.has_key?("MONGOHQ_URL")
    uri = URI.parse(ENV["MONGOHQ_URL"])
    conn = Mongo::Connection.new(uri.host, uri.port).db(uri.path[1..-1])
    conn.authenticate(uri.user, uri.password)
    config.master = conn
  end
end

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

  set :views, root + "views"

  use OmniAuth::Strategies::Twitter,
    omniauth[:consumer_key],
    omniauth[:consumer_secret]

  use Rack::Session::Cookie,
    secret: session_secret

  unless ENV["RACK_ENV"] == "production"
    Sass::Plugin.options[:css_location] = root + "public/css"
    use Sass::Plugin::Rack

    def self.spawn_coffee_watcher(input, output)
      Daemon.spawn("coffee", "coffee --bare --watch --output #{output.to_s.inspect} #{input.to_s.inspect}")
    end

    spawn_coffee_watcher(root + "coffee", root + "public/coffee")
  end

  use Rack::Static,
    root: root + "public",
    urls: ["/js", "/coffee", "/css", "/img", "/favicon.ico"]

  class WwwRedirect
    def initialize(app); @app = app; end

    def call(env)
      domain = env["HTTP_HOST"]
      path   = env["PATH_INFO"]
      www    = /^www\./

      if domain =~ www
        domain = domain.sub(www, '')
        [301, {"Location" => "http://#{domain}#{path}"}, []]
      else
        @app.call(env)
      end
    end
  end

  use WwwRedirect
end

module Nnnnext::Controllers
  class Index
    def get
      @headers["content-type"] = "text/html; charset=utf-8"
      render :index
    end
  end

  class ConcatenatedJavascript < R("/all.js")
    def get
      puts "concatenating javascript..."
      paths = js_files.map { |p| "#{Nnnnext.root}/public#{p}" }
      @headers["Content-Type"] = "text/javascript; charset=utf-8"
      @headers["Cache-Control"] = "public; max-age=3600"
      paths.map { |p| File.read(p) }.join
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

  class Signout
    def get
      @state[:user_id] = nil
      ""
    end
  end

  class AlbumsSearch
    def get
      AlbumSearch.search(@input.q).to_json
    end
  end

  class AlbumsSync
    def post
      if user.nil?
        @status = 401
        return "Unauthorized"
      end

      client_albums  = JSON.parse(@request.body.read)
      updated_albums = Set.new(user.albums)

      client_albums.each do |client_album|
        album_attrs      = client_album.slice("id", "artist", "title")
        user_album_attrs = client_album.except(*album_attrs.keys)
        id               = client_album["id"]
        album            = Models::Album.where(_id: id).first

        if album.nil?
          puts "Album #{id} does not exist on server, creating."
          album = Models::Album.create(album_attrs)
        end

        user_album = updated_albums.find { |ua| ua.album_id == id }

        if user_album
          if user_album.updated < client_album["updated"]
            user_album.update_attributes(user_album_attrs)
            updated_albums.delete(user_album)

            puts "Album #{id} is behind on server (#{user_album.updated} < #{client_album["updated"]})."
            puts "Updated server copy: #{user_album.to_json}"
          elsif user_album.updated > client_album["updated"]
            puts "Album #{id} is behind on client. (#{user_album.updated} > #{client_album["updated"]})"
            puts "Sending updated album: #{user_album.to_json}"
          else
            puts "Album #{id} is in sync. (#{user_album.updated})"
            updated_albums.delete(user_album)
          end
        else
          user_album = user.albums.create(user_album_attrs.merge(album: album))

          puts "Album #{id} is not in user's list on server."
          puts "Created server copy: #{user_album.to_json}"
        end
      end

      @headers["content-type"] = "application/json; charset=utf-8"
      updated_albums.to_a.to_json
    end
  end
end

module Nnnnext::Helpers
  def user
    @user ||= (@state[:user_id] && Nnnnext::Models::User.find(@state[:user_id]))
  end

  def js_includes
    if ENV["CONCATENATE_JS"] == "true"
      ["/all.js?#{File.mtime(__FILE__).to_i}"]
    else
      js_files
    end
  end

  def js_files
    js = %w(jquery
            json2
            underscore
            backbone
            backbone.localStorage
           ).map { |n| "/js/#{n}.js" }

    js += %w(models/album
             views/tabbable
             views/showable
             views/banner
             views/header
             views/album-view
             views/album-list
             views/album-search-bar
             views/new-album-form
             views/friend-list
             sync
             main
            ).map { |n| "/coffee/#{n}.js" }
  end
end

module Nnnnext::Models
  class User
    include Mongoid::Document

    references_many :albums, class_name: "Nnnnext::Models::UserAlbum"
  end

  class UserAlbum
    include Mongoid::Document

    referenced_in :user,  class_name: "Nnnnext::Models::User"

    field :state,        type: String
    field :stateChanged, type: Integer
    field :rating,       type: Integer
    field :updated,      type: Integer
    field :album_id,     type: String

    def album
      @album ||= Album.find(album_id)
    end

    def album=(a)
      self.album_id = (a.id)
      @album = a
    end

    def as_json(options=nil)
      attributes.except(:_id, :user_id, :album_id).merge(
        id:      album.id,
        artist:  album.artist,
        title:   album.title,
      ).as_json(options)
    end
  end

  class Album
    include Mongoid::Document

    identity type: String

    field :artist, type: String
    field :title,  type: String
  end
end

