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

run Camping::Apps.first
