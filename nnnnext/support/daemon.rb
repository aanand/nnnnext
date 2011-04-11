module Daemon
  def self.spawn(name, cmd, pid_file="tmp/#{name}.pid", log_file="log/#{name}.log")
    cmd = "#{cmd} 2>&1 > #{log_file}"

    pid = pids[name] || read_pid_file(pid_file)

    if pid
      begin
        Process.getpgid(pid.to_i)
        puts "daemon.rb: #{name} already running with pid #{pid}"
      rescue
        puts "daemon.rb: #{pid_file} contains pid #{pid}, but no process found"
        pid = nil
      end
    end

    if !pid
      puts "daemon.rb: spawning command: #{cmd}"
      pid = Process.spawn(cmd)
      pids[name] = pid
      Process.detach(pid)
      File.open(pid_file, "w") { |f| f.puts(pid) }
      puts "daemon.rb: #{name} started with pid #{pid}"
    end

    trap "EXIT" do
      File.unlink(pid_file)
    end

    pid
  end

  def self.read_pid_file(pid_file)
    puts "daemon.rb: reading from #{pid_file}"
    File.readable?(pid_file) && File.read(pid_file).strip
  end

  def self.pids
    @pids ||= {}
  end
end

