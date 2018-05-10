SecureHeaders::Configuration.default do |config|
  config.hsts = SecureHeaders::OPT_OUT

  asset_src = ["'self'", "'unsafe-inline'", ENV['ASSET_HOST']].compact

  script_src = asset_src + [
    'https://www.google-analytics.com',
    'https://cdnjs.cloudflare.com'
  ]

  config.csp = {
    preserve_schemes: true,
    default_src: ["'none'"],
    child_src: ["'self'"],
    connect_src: ["'self'", 'https://api.rollbar.com'],
    font_src: ["'self'", 'https:', 'data:'],
    img_src: ["'self'", 'https:', 'data:'],
    script_src: script_src,
    style_src: asset_src
  }
end
