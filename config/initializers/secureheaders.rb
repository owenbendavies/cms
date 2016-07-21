SecureHeaders::Configuration.default do |config|
  config.hsts = :opt_out_of_protection

  default_src = ["'self'", "'unsafe-inline'", ENV['ASSET_HOST']]

  config.csp = {
    preserve_schemes: true,
    default_src: ["'none'"],
    child_src: ["'self'"],
    connect_src: ["'self'"],
    font_src: ["'self'", 'https:'],
    img_src: ["'self'", 'https:', 'data:'],
    script_src: default_src + ['https://www.google-analytics.com'],
    style_src: default_src + [CarrierWave::Uploader::Base.asset_host]
  }
end
