Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true

  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.active_support.deprecation = :notify

  config.serve_static_files   = true
  config.static_cache_control = 'public, max-age=31536000'

  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  config.assets.compile = false
  config.assets.digest = true

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # config.force_ssl = true

  config.log_level = :info
  config.logger = Logger.new(STDOUT)
  config.lograge.enabled = true

  config.action_controller.asset_host = Rails.application.secrets.asset_host

  config.i18n.fallbacks = true
end
