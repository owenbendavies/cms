Raven.configure do |config|
  if Rails.application.secrets.sentry_dsn
    config.dsn = Rails.application.secrets.sentry_dsn
  end

  config.excluded_exceptions = []

  config.ssl_verification = true
end
