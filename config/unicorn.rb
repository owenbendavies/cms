require 'syslogger'
logger Syslogger.new("cms")

worker_processes 4

timeout 5

preload_app true

working_directory '/var/www/cms/current'

pid '/var/run/cms.pid'

listen '/var/run/cms.socket'

before_fork do |server, worker|
  if File.exists? '/var/run/cms.pid.oldbin'
    begin
      Process.kill("QUIT", File.read('/var/run/cms.pid.oldbin').to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end
