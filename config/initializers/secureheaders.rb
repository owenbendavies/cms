SecureHeaders::Configuration.default do |config|
  config.hsts = :opt_out_of_protection

  default_src = ["'self'", "'unsafe-inline'", Rails.application.secrets.asset_host]

  config.csp = {
    preserve_schemes: true,
    default_src: %w('none'),
    connect_src: %w('self'),
    font_src: %w('self' https:),
    img_src: %w('self' https: data:),
    script_src: default_src + ['https://www.google-analytics.com'],
    style_src: default_src + [Rails.application.secrets.s3_host]
  }
end
