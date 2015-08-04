Rack::Timeout.timeout = Rails.application.secrets.timeout || 3
Rack::Timeout.unregister_state_change_observer(:logger)
