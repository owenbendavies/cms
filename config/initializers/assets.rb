# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '5.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.public_file_server.enabled = true

if ENV['DEV_ASSETS']
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  Rails.application.config.assets.debug = true

  # Suppress logger output for asset requests.
  Rails.application.config.assets.quiet = true
else
  # Compress JavaScripts and CSS.
  Rails.application.config.assets.css_compressor = :sass
  Rails.application.config.assets.js_compressor = :uglifier

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  Rails.application.config.assets.compile = false

  Rails.application.config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.year.to_i}"
  }
end
