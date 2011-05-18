require "haml"

module Nnnnext::Assets
  module_function

  PATHS = {
    "index.html"     => :index,
    "cache.manifest" => :manifest,
    "all.js"         => :js
  }

  CONTENT_TYPES = {
    index:    "text/html",
    manifest: "text/cache-manifest",
    js:       "application/javascript"
  }

  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      path = env["PATH_INFO"].sub(%r{^/}, "")
      path = "index.html" if path.empty?
      
      if PATHS.has_key?(path)
        name         = PATHS[path]
        data         = Nnnnext::Assets.send(name)
        content_type = CONTENT_TYPES[name]

        [200, {"Content-Type" => "#{content_type}; charset=utf-8"}, [data]]
      else
        @app.call(env)
      end
    end
  end

  def generate_all
    PATHS.each do |path, name|
      File.open("public/#{path}", "w") { |f| f.write(send(name)) }
    end
  end

  def index
    template = File.read("views/index.haml")
    engine = Haml::Engine.new(template)
    engine.render(self)
  end

  def manifest
    paths = ["/favicon.ico"]
    paths += ["/css/desktop.css", "/css/mobile.css"]
    paths += js_includes

    Dir["public/img/*"].each do |p|
      paths << "/img/#{File.basename(p)}"
    end

    mtime = paths.map { |p| File.mtime("public"+p) }.max

    lines = ["CACHE MANIFEST", "\# version #{mtime}", "", "CACHE:"] + paths + ["", "NETWORK:", "*"]
    lines.join "\n"
  end

  def js
    paths = js_files.map { |p| "public" + p }
    paths.map { |p| File.read(p) }.join
  end

  def js_includes
    if Nnnnext.env["CONCATENATE_JS"].to_s == "true"
      ["/all.js"]
    else
      js_files
    end
  end

  def js_files
    js = %w(jquery
            jquery.insertAt
            jquery.sitDownMan
            jquery.tappable
            json2
            underscore
            backbone
            backbone.localStorage
            debug-cache
           ).map { |n| "/js/#{n}.js" }

    js += %w(setup
             models/album
             models/user
             collections/album-collection
             collections/filtered-collection
             views/view-shop
             views/view
             views/list
             views/openable
             views/links
             views/about-page
             views/header
             views/navigation
             views/hint
             views/list-manager
             views/album-view
             views/album-list
             views/album-search-bar
             views/new-album-form
             views/friend-view
             views/friend-list
             views/friend-browser
             views/app-view
             hint
             collections
             sync
             main
            ).map { |n| "/coffee/#{n}.js" }
  end

  def google_analytics_account
    Nnnnext.env["GOOGLE_ANALYTICS_ACCOUNT"]
  end
end

