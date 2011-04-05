ENV["PATH"] = "/usr/local/bin:#{ENV['PATH']}"

if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    if forked
      Mongoid.database.connection.reconnect
    end
  end
end

if ENV["RACK_ENV"] == "production"
  LOGGER = STDOUT

  $:.unshift "."
  require "nnnnext"
  run Camping::Apps.first
else
  LOGGER = File.open(File.expand_path("../log/development.log", __FILE__), "a")
  LOGGER.sync = true
  STDOUT.reopen(LOGGER)
  STDERR.reopen(LOGGER)

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
