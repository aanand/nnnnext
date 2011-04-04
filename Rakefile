require 'uri'

task :console do
  system "bundle exec irb -I. -rnnnnext"
end

module MongoDumpTasks
  namespace :mongo do
    namespace :dump do
      desc "Download a dump of the remote MongoDB database to your machine"
      task :remote do
        mongodump(remote_dump_dir, remote_args)
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

    namespace :upload do
      desc "Upload the last remote MongoDB dump to the live MongoDB instance - USE WITH CAUTION."
      task :remote do
        confirm("WARNING: going to upload the last REMOTE MongoDB dump (#{remote_dump_dir}) to the live MongoDB instance.\nAre you sure you want to do this?")
        mongorestore(remote_dump_dir, remote_args)
      end

      desc "Upload the last local MongoDB dump to the live MongoDB instance - USE WITH CAUTION."
      task :local do
        confirm("WARNING: going to upload the last LOCAL MongoDB dump (#{local_dump_dir}) to the live MongoDB instance.\nAre you sure you want to do this?")
        mongorestore(local_dump_dir, remote_args)
      end
    end
  end

  module_function

  def confirm(message)
    print "#{message} [yN] "
    exit(1) unless $stdin.gets.chomp.downcase == "y"
  end

  def mongodump(dump_dir, args)
    system "mongodump --out #{dump_dir} #{args}"
  end

  def mongorestore(dump_dir, args)
    system "mongorestore --drop #{get_restore_dir(dump_dir)} #{args}"
  end

  def get_restore_dir(dump_dir)
    Dir["#{dump_dir}/*"].first
  end

  def remote_args
    %W(
      --host=#{uri.host}:#{uri.port}
      --username=#{uri.user}
      --password=#{uri.password}
      --db=#{remote_db_name}
    ).join(" ")
  end

  def local_args
    "--db=#{local_db_name}"
  end

  def local_db_name
    "nnnnext_development"
  end

  def remote_db_name
    uri.path.sub(%r{^/}, "")
  end

  def local_dump_dir
    "db/dump/local"
  end

  def remote_dump_dir
    "db/dump/remote"
  end

  def uri
    @uri ||= URI.parse(mongohq_url)
  end

  def mongohq_url
    @mongohq_url ||= run(%Q(heroku console "puts ENV['MONGOHQ_URL']")).split("\n").first
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
