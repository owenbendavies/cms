SecureHeaders::Configuration.default do |config|
  config.x_frame_options = 'DENY'

  config.referrer_policy = 'strict-origin-when-cross-origin'

  asset_src = [
    "'self'",
    "'unsafe-inline'",
    ENV['AWS_S3_ASSET_HOST']
  ].compact

  script_src = asset_src + [
    'https://www.google-analytics.com',
    'https://cdnjs.cloudflare.com'
  ]

  connect_src = [
    "'self'",
    'https://api.rollbar.com'
  ]

  connect_src += ['http://localhost:3035', 'ws://localhost:3035'] if Rails.env.development?

  config.csp = {
    preserve_schemes: true,
    default_src: ["'none'"],
    child_src: ["'self'"],
    connect_src: connect_src,
    font_src: ["'self'", 'https:', 'data:'],
    img_src: ["'self'", 'https:', 'data:'],
    script_src: script_src,
    style_src: asset_src
  }
end
