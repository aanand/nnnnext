require 'uri'
require 'net/ssh/gateway'

task :console do
  system "bundle exec irb -I. -rnnnnext"
end

task :assets => :env do
  Nnnnext::Assets.generate_all
end

task :env do
  $:.unshift "."
  require "nnnnext"
end

module MongoDumpTasks
  namespace :mongo do
    namespace :dump do
      desc "Download a dump of the remote MongoDB database to your machine"
      task :remote do
        mongodump(remote_dump_dir, remote_args, true)
      end

      desc "Dump the local MongoDB database to your machine"
      task :local do
        mongodump(local_dump_dir, local_args)
      end
    end

    namespace :import do
      desc "Import the last remote MongoDB dump into the local MongoDB instance"
      task :remote do
        mongorestore(remote_dump_dir, local_args)
      end

      desc "Import the last local MongoDB dump into the local MongoDB instance"
      task :local do
        mongorestore(local_dump_dir, local_args)
      end
    end
  end

  module_function

  def confirm(message)
    print "#{message} [yN] "
    exit(1) unless $stdin.gets.chomp.downcase == "y"
  end

  def mongodump(dump_dir, args, tunnel=false)
    with_tunnel(tunnel) do
      system "mongodump --out #{dump_dir} #{args}"
    end
  end

  def mongorestore(dump_dir, args)
    system "mongorestore --drop #{get_restore_dir(dump_dir)} #{args}"
  end

  def with_tunnel(yes)
    if yes
      begin
        puts "opening tunnel to #{remote_host}..."
        gateway = Net::SSH::Gateway.new(remote_host, remote_user, verbose: :warn)
        port = gateway.open("localhost", remote_port, tunnel_port)
        yield
      ensure
        if gateway
          puts "shutting down tunnel..."
          gateway.shutdown!
        end
      end
    else
      yield
    end
  end

  def get_restore_dir(dump_dir)
    Dir["#{dump_dir}/*"].first
  end

  def local_args
    "--db=#{local_db_name}"
  end

  def remote_args
    "--db=#{remote_db_name} --port=#{tunnel_port}"
  end

  def remote_user
    "aanand"
  end

  def remote_host
    "nnnnext.com"
  end

  def remote_port
    27017
  end

  def tunnel_port
    remote_port + 1
  end

  def local_db_name
    "nnnnext_development"
  end

  def remote_db_name
    "nnnnext_production"
  end

  def local_dump_dir
    "db/dump/local"
  end

  def remote_dump_dir
    "db/dump/remote"
  end

  def run(cmd)
    puts("* #{cmd}")
    `#{cmd}`
  end

  def system(cmd)
    puts("* #{cmd}")
    Kernel.system(cmd)
  end
end
