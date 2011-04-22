ENV["PATH"] = "/usr/local/bin:#{ENV['PATH']}"

STDOUT.sync = true
STDERR.sync = true

$:.unshift "."
require "nnnnext"
run Camping::Apps.first
