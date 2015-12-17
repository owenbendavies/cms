if defined?(Raven) && Rails.application.secrets.sentry_dsn
  Raven.configure do |config|
    config.dsn = Rails.application.secrets.sentry_dsn

    config.excluded_exceptions = [
      'ActionController::RoutingError'
    ]

    config.ssl_verification = true

    config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  end
end
