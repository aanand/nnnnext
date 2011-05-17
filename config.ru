STDOUT.sync = true
STDERR.sync = true

$:.unshift "."
require "nnnnext"

if api_key = Nnnnext.env["HOPTOAD_API_KEY"]
  require 'hoptoad_notifier'

  HoptoadNotifier.configure do |config|
    config.api_key = api_key
  end

  use HoptoadNotifier::Rack
end

unless ENV["RACK_ENV"] == "production"
  use Nnnnext::Assets::Middleware

  use Rack::Static,
    root: File.expand_path("../public", __FILE__),
    urls: ["/js", "/coffee", "/css", "/img", "/favicon.ico"]
end

run Camping::Apps.first
