require 'syslogger'
logger Syslogger.new('cms')

worker_processes Integer(ENV['WORKER_PROCESSES'])

timeout 5

preload_app true

DEPLOY_PATH = '/var/www/cms/current'

working_directory DEPLOY_PATH

PID_FILE = File.join(DEPLOY_PATH, '/tmp/pids/unicorn.pid')
OLD_PID_FILE = PID_FILE + '.oldbin'

pid PID_FILE

listen File.join(DEPLOY_PATH, '/tmp/sockets/unicorn.sock')

before_exec do |_|
  ENV['BUNDLE_GEMFILE'] = File.join(DEPLOY_PATH, 'Gemfile')
end

before_fork do |_, _|
  ActiveRecord::Base.connection.disconnect!

  if File.exist?(OLD_PID_FILE)
    Process.kill('QUIT', File.read(OLD_PID_FILE).to_i)
  end
end

after_fork do |_, _|
  ActiveRecord::Base.establish_connection
end
