require "bundler"
Bundler.setup

# stdlib
require "json"
require "uri"

# gems
require "camping"
require "oa-oauth"
require "mongoid"

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
end

$LOAD_PATH.unshift(Nnnnext.root) unless $LOAD_PATH.include?(Nnnnext.root)

Dir.glob(Nnnnext.root + "nnnnext/{support/**/*.rb,**/*.rb}").each do |path|
  path = path.sub("#{Nnnnext.root}/", "")
  require path
end

