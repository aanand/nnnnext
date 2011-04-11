ENV["PATH"] = "/usr/local/bin:#{ENV['PATH']}"

STDOUT.sync = true
STDERR.sync = true

if ENV["RACK_ENV"] == "production"
  $:.unshift "."
  require "nnnnext"
  run Camping::Apps.first
else
  require "bundler"
  Bundler.setup
  require "camping"
  require "camping/reloader"

  path = File.expand_path("../nnnnext.rb", __FILE__)
  reloader = Camping::Reloader.new(path)

  app = proc do |env|
    reloader.update(path)
    reloader.apps.values.first.call(env)
  end

  run app
end
