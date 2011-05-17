STDOUT.sync = true
STDERR.sync = true

$:.unshift "."
require "nnnnext"

unless ENV["RACK_ENV"] == "production"
  use Nnnnext::Assets::Middleware

  use Rack::Static,
    root: File.expand_path("../public", __FILE__),
    urls: ["/js", "/coffee", "/css", "/img", "/favicon.ico"]
end

class WwwRedirect
  def initialize(app)
    @app = app
  end

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

run Camping::Apps.first
