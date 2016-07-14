Rack::Timeout.timeout = Integer(ENV['WEB_TIMEOUT'] || 2)
Rack::Timeout::Logger.disable
