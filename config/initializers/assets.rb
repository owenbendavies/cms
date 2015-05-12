Rails.application.config.assets.version = '3.0'

Rails.application.config.serve_static_files = true

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are
# already added.
# Rails.application.config.assets.precompile += %w( search.js )

if Rails.application.secrets.dev_assets
  Rails.application.config.assets.debug = true
  Rails.application.config.assets.raise_runtime_errors = true
else
  Rails.application.config.assets.compile = false
  Rails.application.config.assets.digest = true
  Rails.application.config.assets.css_compressor = :sass
  Rails.application.config.assets.js_compressor = :uglifier
end
