STDOUT.sync = true
STDERR.sync = true

$:.unshift "."
require "nnnnext"

if ENV["RACK_ENV"] == "production"
  require 'hoptoad_notifier'

  HoptoadNotifier.configure do |config|
    config.api_key = 'f5e3e91d2de360d1824ea92b54e38c9d'
  end

  use HoptoadNotifier::Rack
else
  use Nnnnext::Assets::Middleware

  use Rack::Static,
    root: File.expand_path("../public", __FILE__),
    urls: ["/js", "/coffee", "/css", "/img", "/favicon.ico"]
end

run Camping::Apps.first
