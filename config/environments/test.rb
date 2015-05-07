Rails.application.configure do
  config.cache_classes = true
  config.eager_load = false

  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false

  config.active_support.deprecation = :stderr

  config.serve_static_files = true
  config.static_cache_control = 'public, max-age=3600'

  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  config.assets.compile = false
  config.assets.digest = true

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  config.action_controller.allow_forgery_protection = false

  config.action_mailer.delivery_method = :test

  config.after_initialize do
    Bullet.enable = true
    Bullet.raise = true

    Bullet.add_whitelist(
      type: :n_plus_one_query,
      class_name: 'Site',
      association: :users
    )
  end
end
