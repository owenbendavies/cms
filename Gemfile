source 'https://rubygems.org'
ruby '2.1.2'

# Application Gems
gem 'rails', '4.0.8'

# Middleware
gem 'rack-protection'
gem 'rack-timeout', '0.1.0beta3'
gem 'rails_warden'

# Model Gems
gem 'auto_strip_attributes'
gem 'bcrypt'
gem 'carrierwave', '0.9.0'
gem 'couch_potato'
gem 'fog', '1.18.0'
gem 'gravtastic'
gem 'mini_magick'
gem 'unf'
gem 'validates_email_format_of'

# Controller Gems
gem 'xml-sitemap'

# View Gems
gem 'haml'
gem 'simple_form'

# Stylesheets
gem 'less-rails'
gem 'twitter-bootstrap-rails'
gem 'twitter-bootstrap-rails-confirm', '1.0.1'

# Javscript
gem 'sprockets', '2.10.1'
gem 'google-analytics-rails'
gem 'google-analytics-turbolinks'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'rails-timeago'
gem 'therubyracer'
gem 'tinymce-rails', '4.0.19'
gem 'turbolinks'
gem 'turbolinks_transitions'
gem 'uglifier'

# Monitoring
gem 'lograge'
gem 'newrelic_rpm'
gem 'sentry-raven'
gem 'syslogger'

# System management
gem 'figaro'

group :heroku do
  gem 'heroku-deflater'
  gem 'rails_12factor'
end

group :production do
  gem 'unicorn'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.0'
  gem 'travis-lint'
end

group :development do
  gem 'byebug'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv'
  gem 'quiet_assets'
  gem 'thin'
end

group :test do
  gem 'capybara-webkit'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'shoulda-matchers', require: false
  gem 'timecop'

  # Code quality tools
  gem 'brakeman', require: false
  gem 'cane', require: false
  gem 'coveralls', require: false
  gem 'rails_best_practices', require: false
  gem 'simplecov-console', require: false
end
