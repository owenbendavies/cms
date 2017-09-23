SecureHeaders::Configuration.default do |config|
  config.hsts = SecureHeaders::OPT_OUT

  default_src = ["'self'", "'unsafe-inline'", ENV['ASSET_HOST']]

  config.csp = {
    preserve_schemes: true,
    default_src: ["'none'"],
    child_src: ["'self'"],
    connect_src: ["'self'", 'https://api.rollbar.com'],
    font_src: ["'self'", 'https:'],
    img_src: ["'self'", 'https:', 'data:'],
    script_src: default_src + [
      'https://www.google-analytics.com',
      'https://cdnjs.cloudflare.com'
    ],
    style_src: default_src + [CarrierWave::Uploader::Base.asset_host]
  }
end
