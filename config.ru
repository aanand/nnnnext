ENV["PATH"] = "/usr/local/bin:#{ENV['PATH']}"

$:.unshift "."
require "nnnnext"

run Camping::Apps.first
