SecureHeaders::Configuration.default do |config|
  config.hsts = false

  config.csp = {
    enforce: true,
    default_src: %w('none'),
    connect_src: %w('self'),
    font_src: %w('self' https:),
    img_src: %w('self' https: data:),
    script_src: %w('self' https: 'unsafe-inline'),
    style_src: %w('self' https: 'unsafe-inline')
  }
end
