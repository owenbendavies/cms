Rack::Timeout.timeout = Integer(ENV['TIMEOUT'] || 2)
Rack::Timeout::Logger.disable
