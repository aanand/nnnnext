require "bundler"
Bundler.setup

# stdlib
require "json"
require "uri"

# gems
require "camping"
require "mongoid"

Mongoid.configure do |config|
  host = ENV.fetch("ORCHARD_MONGODB_HOST")
  puts "Connecting to #{host}"
  conn = Mongo::Connection.new(host).db("nnnnext")
  config.master = conn
end

Camping.goes :Nnnnext

Dir.glob("nnnnext/{support/**/*.rb,**/*.rb}").each do |path|
  require path
end

