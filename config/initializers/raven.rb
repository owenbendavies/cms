Raven.configure do |config|
  if Rails.application.secrets.sentry_dsn
    config.dsn = Rails.application.secrets.sentry_dsn
  end

  config.environments = ['production']
  config.ssl_verification = true
end
