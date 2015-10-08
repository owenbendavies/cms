Rack::Timeout.timeout = Integer(Rails.application.secrets.timeout)
Rack::Timeout.unregister_state_change_observer(:logger)
