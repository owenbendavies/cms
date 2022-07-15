SecureHeaders::Configuration.default do |config|
  config.x_frame_options = 'DENY'

  config.referrer_policy = 'strict-origin-when-cross-origin'

  asset_src = ["'self'", "'unsafe-inline'", Rails.configuration.x.aws_s3_asset_host].compact

  connect_src = [
    "'self'",
    'https://*.doubleclick.net',
    'https://*.rollbar.com',
    Rails.configuration.x.aws_cognito_domain
  ]

  connect_src += ['http://localhost:3035', 'ws://localhost:3035'] if Rails.env.development?

  script_src = asset_src + [
    "'unsafe-eval'",
    'https://*.cloudflare.com',
    'https://*.google-analytics.com',
    'https://*.rollbar.com'
  ]

  config.csp = {
    preserve_schemes: true,
    default_src: ["'none'"],
    child_src: ["'self'"],
    connect_src:,
    font_src: ["'self'", 'https:', 'data:'],
    img_src: ["'self'", 'https:', 'data:'],
    script_src:,
    style_src: asset_src
  }
end
