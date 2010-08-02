module ForegroundShellout
  def shellout(*cmd)
    puts "in #{Dir.pwd}"
    puts "sh(#{cmd.join(' ')})"
    pid = fork do
      exec(cmd.join(' '))
    end
    pid, status = Process.waitpid2(pid)
    raise "shell command failed" unless status.success?
  end
end