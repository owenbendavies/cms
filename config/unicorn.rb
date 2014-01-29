require 'syslogger'
logger Syslogger.new("cms")

worker_processes 4

timeout 5

preload_app true

DEPLOY_PATH = File.expand_path('../..', __FILE__)

working_directory DEPLOY_PATH

PID_FILE = File.join(DEPLOY_PATH, "/tmp/pids/unicorn.pid")
OLD_PID_FILE = PID_FILE + ".oldbin"

pid PID_FILE

listen File.join(DEPLOY_PATH, "/tmp/sockets/unicorn.sock")

before_fork do |server, worker|
  if File.exists?(OLD_PID_FILE)
    begin
      Process.kill("QUIT", File.read(OLD_PID_FILE).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end
