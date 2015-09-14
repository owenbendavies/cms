if defined?(Raven) && Rails.application.secrets.sentry_dsn
  Raven.configure do |config|
    config.dsn = Rails.application.secrets.sentry_dsn

    config.excluded_exceptions = []

    config.ssl_verification = true
  end
end
