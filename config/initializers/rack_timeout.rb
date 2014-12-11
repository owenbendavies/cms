Rack::Timeout.timeout = 3
Rack::Timeout.unregister_state_change_observer(:logger)
