require 'syslogger'
logger Syslogger.new('cms')

worker_processes Integer(ENV['WORKER_PROCESSES'])

timeout 5

preload_app true

DEPLOY_PATH = File.expand_path('../..', __FILE__)

working_directory DEPLOY_PATH

pid File.join(DEPLOY_PATH, '/tmp/pids/unicorn.pid')

listen File.join(DEPLOY_PATH, '/tmp/sockets/unicorn.sock')
