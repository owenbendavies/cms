source 'https://rubygems.org'
ruby '2.0.0'

# Application Gems
gem 'rails', '4.0.2'

# Middleware
gem 'rack-protection'
gem 'rack-timeout'
gem 'rails_warden'

# Model Gems
gem 'couch_potato'
gem 'bcrypt-ruby'
gem 'validates'
gem 'ipaddress'
gem 'rails_ip_validator'
gem 'auto_strip_attributes'
gem 'gravtastic'
gem 'unf'
gem 'carrierwave'
gem 'mini_magick'

# Controller Gems
gem 'xml-sitemap'

# View Gems
gem 'haml'
gem 'simple_form'
gem 'google-analytics-rails'
gem 'rails-timeago'
gem 'tinymce-rails'

# Assets
gem 'fog', '1.18.0'
gem 'asset_sync'

# Stylesheets
gem 'less-rails'
gem 'twitter-bootstrap-rails'
gem 'twitter-bootstrap-rails-confirm', '1.0.1'

# Javscript
gem 'therubyracer'
gem 'uglifier'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'turbolinks_transitions'
gem 'google-analytics-turbolinks'

# Monitoring
gem 'lograge'
gem 'newrelic_rpm'
gem 'sentry-raven'
gem 'syslogger'

# System management
gem 'figaro'
gem 'whenever', require: false

group :heroku do
  gem 'rails_12factor'
end

group :production do
  gem 'unicorn'
end

group :development, :test do
  gem 'rspec-core'
  gem 'rspec-rails', '~> 2.0'
  gem 'travis-lint'
end

group :development do
  gem 'capistrano-rails'
  gem 'quiet_assets'
  gem 'byebug'
  gem 'thin'
  gem 'mailcatcher'
end

group :test do
  gem 'fuubar'
  gem 'timecop'
  gem 'faker'
  gem 'factory_girl_rails'
  gem 'remarkable_activemodel', require: 'remarkable/active_model'
  gem 'capybara-webkit'

  # Code quality tools
  gem 'coveralls', require: false
  gem 'simplecov-console', require: false
  gem 'cane', require: false
  gem 'brakeman', require: false
  gem 'rails_best_practices', require: false
end
