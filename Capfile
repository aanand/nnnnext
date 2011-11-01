$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                               # Load RVM's capistrano plugin.
set :rvm_type, :user

set :host,        "nnnnext.com"
set :user,        "aanand"
set :application, "nnnnext"

set :deploy_to, "/home/#{user}/#{application}"

role :web, host

task :deploy do
  run "cd #{deploy_to} && git config receive.denyCurrentBranch warn"
  sh "git push #{user}@#{host}:#{deploy_to} HEAD:master"
  run "cd #{deploy_to} && git reset --hard master"
end

task :bundle do
  run "cd #{deploy_to} && bundle"
end

task :assets do
  run "cd #{deploy_to} && rake assets"
end

task :restart do
  run "cd #{deploy_to} && touch tmp/restart.txt"
end

after :deploy, :bundle
after :deploy, :assets
after :deploy, :restart

def sh(cmd)
  puts "  * executing `#{cmd}` locally"
  raise "command failed" unless system(cmd)
end
