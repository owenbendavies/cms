source 'https://rubygems.org'
ruby '2.1.5'

gem 'rails', '4.1.8'

# Databases
gem 'pg'
gem 'redis-actionpack'

# Middleware
gem 'rack-protection'
gem 'rack-timeout', '0.1.0beta3'
gem 'rails_warden'

# Model Gems
gem 'bcrypt'
gem 'carrierwave', '0.9.0'
gem 'carrierwave_couch_potato'
gem 'couch_potato'
gem 'fog', '1.18.0'
gem 'gravtastic'
gem 'mini_magick'
gem 'strip_attributes'
gem 'unf'
gem 'validates_email_format_of'
gem 'zxcvbn-ruby', require: 'zxcvbn'

# Controller Gems
gem 'xml-sitemap'

# View Gems
gem 'haml-rails'
gem 'simple_form'

# Assets
gem 'coffee-rails'
gem 'google-analytics-turbolinks'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'less-rails'
gem 'rails-timeago'
gem 'therubyracer'
gem 'tinymce-rails'
gem 'turbolinks'
gem 'turbolinks_transitions'
gem 'twitter-bootstrap-rails', github: 'obduk/twitter-bootstrap-rails', branch: 'remove_rails_dependency'
gem 'twitter-bootstrap-rails-confirm', github: 'obduk/twitter-bootstrap-rails-confirm', branch: 'fix_events'
gem 'uglifier'

# Monitoring
gem 'lograge'
gem 'newrelic_rpm'
gem 'syslogger'

# Server
gem 'unicorn-rails'

group :production do
  gem 'sentry-raven'
end

group :development, :test do
  gem 'annotate'
end

group :development do
  gem 'byebug'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'quiet_assets'
end

group :test do
  gem 'capybara-webkit'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'shoulda-matchers', require: false
  gem 'spring-commands-rspec'
  gem 'timecop'

  # Code quality tools
  gem 'brakeman', require: false
  gem 'cane', require: false
  gem 'coveralls', require: false
  gem 'rails_best_practices', require: false
  gem 'simplecov-console', require: false
  gem 'travis-lint', require: false
end
