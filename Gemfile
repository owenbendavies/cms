source 'https://rubygems.org'
ruby '2.2.0'

gem 'rails', '4.2.0'

# Databases
gem 'pg'
gem 'redis-actionpack'

# Middleware
gem 'rack-protection'
gem 'rack-timeout'
gem 'rails_warden'

# Model Gems
gem 'bcrypt'
gem 'fog', require: 'fog/aws/storage'
gem 'carrierwave'
gem 'gravtastic'
gem 'mini_magick'
gem 'paper_trail'
gem 'strip_attributes'
gem 'unf'
gem 'validates_email_format_of'
gem 'zxcvbn-ruby', require: 'zxcvbn'

# Controller Gems
gem 'xml-sitemap'

# View Gems
gem 'bh'
gem 'haml-rails'
gem 'simple_form'

# Assets
gem 'autoprefixer-rails'
gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'google-analytics-turbolinks'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'rails-timeago'
gem 'sass-rails'
gem 'therubyracer'
gem 'tinymce-rails'
gem 'turbolinks'

gem(
  'twitter-bootstrap-rails-confirm',
  github: 'obduk/twitter-bootstrap-rails-confirm',
  branch: 'fix_events'
)

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
  gem 'database_cleaner'
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
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'simplecov-console', require: false
  gem 'travis-lint', require: false
end
