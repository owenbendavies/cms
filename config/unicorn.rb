preload_app true
timeout 5
worker_processes Integer(ENV['WORKER_PROCESSES'] || 1)

before_fork do |_server, _worker|
  ActiveRecord::Base.connection.disconnect!
end

after_fork do |_server, _worker|
  ActiveRecord::Base.establish_connection
  Redis.current.disconnect!
end
