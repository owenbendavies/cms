# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '4.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

# Asset digests allow you to set far-future HTTP expiration dates on all assets,
# yet still be able to expire them through the digest params.
Rails.application.config.assets.digest = true

Rails.application.config.serve_static_files = true

if ENV['DEV_ASSETS']
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  Rails.application.config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  Rails.application.config.assets.raise_runtime_errors = true
else
  # Compress JavaScripts and CSS.
  Rails.application.config.assets.css_compressor = :sass
  Rails.application.config.assets.js_compressor = :uglifier

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  Rails.application.config.assets.compile = false

  Rails.application.config.static_cache_control = "public, max-age=#{1.year.to_i}"
end
