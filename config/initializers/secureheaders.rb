SecureHeaders::Configuration.configure do |config|
  config.hsts = { max_age: 1.month.to_i }

  config.x_xss_protection = { value: 1, mode: 'block' }

  config.csp = {
    default_src: "'self' https:",
    enforce: true,
    script_src: "'self' https: 'unsafe-inline'",
    style_src: "'self' https: 'unsafe-inline'"
  }
end
