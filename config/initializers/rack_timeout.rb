Rack::Timeout.timeout = Integer(Rails.application.secrets.timeout)
Rack::Timeout::Logger.disable
