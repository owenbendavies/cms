Raven.configure do |config|
  config.dsn = Rails.application.secrets.sentry_dsn
  config.environments = ['production']
  config.ssl_verification = true
end
