SecureHeaders::Configuration.configure do |config|
  config.hsts = { max_age: 1.month.to_i }

  config.x_xss_protection = { value: 1, mode: 'block' }

  config.csp = {
    enforce: true,
    default_src: "'none'",
    connect_src: "'self'",
    font_src: "'self' https:",
    img_src: "'self' https: data:",
    script_src: "'self' https: 'unsafe-inline'",
    style_src: "'self' https: 'unsafe-inline'"
  }
end
