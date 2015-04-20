source 'https://rubygems.org'
ruby '2.2.1'

# Frameworks
gem 'rails', '4.2.1'
gem 'devise'
gem 'devise_zxcvbn'

# Databases
gem 'pg'
gem 'redis-actionpack'

# Middleware
gem 'rack-protection'
gem 'rack-timeout'

# Model Gems
gem 'auto_validate'
gem 'fog'
gem 'carrierwave'
gem 'gravtastic'
gem 'mini_magick'
gem 'paper_trail'
gem 'phone'
gem 'strip_attributes'
gem 'unf'
gem 'validates_email_format_of'

# Controller Gems
gem 'secure_headers'
gem 'xml-sitemap'

# View Gems
gem 'bh'
gem 'haml-rails'
gem 'premailer-rails'
gem 'simple_form'

# Assets
gem 'autogrow-textarea-rails'
gem 'bootstrap-sass'
gem 'font-awesome-sass'
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

# Server
gem 'unicorn-rails'

group :production do
  gem 'font_assets'
  gem 'heroku-deflater'
  gem 'newrelic_rpm'
  gem 'sentry-raven'
end

group :development, :test do
  gem 'pry-byebug'
  gem 'pry-rails'

  # Code quality tools
  gem 'brakeman', require: false
  gem 'bullet'
  gem 'cane', require: false
  gem 'coffeelint'
  gem 'coveralls', require: false
  gem 'haml-lint', require: false
  gem 'i18n-tasks', require: false
  gem 'puppet-lint', require: false
  gem 'rails_best_practices', require: false
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'scss-lint', require: false
  gem 'simplecov-console', require: false
end

group :development do
  gem 'annotate'
  gem 'letter_opener_web'
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
  gem 'webmock'
end
