require 'rack/timeout/rollbar'

Rack::Timeout.service_timeout = Integer(ENV['WEB_TIMEOUT'] || 2)
Rack::Timeout::Logger.disable
