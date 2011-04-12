module Nnnnext
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
