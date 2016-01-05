source 'https://rubygems.org'
ruby '2.2.4'

# Frameworks
gem 'rails'
gem 'delayed_job_active_record'

# Databases
gem 'pg'
gem 'redis-actionpack'

# Rack middleware
gem 'rack-protection'
gem 'rack-timeout'

# Authentication and authorization
gem 'cancancan'
gem 'devise'
gem 'devise_invitable'
gem 'devise_zxcvbn'

# Required for carrierwave to be loaded before
gem 'fog'
gem 'net-ssh'

# Model Gems
gem 'acts_as_list'
gem 'carrierwave'
gem 'gravtastic'
gem 'mini_magick'
gem 'paper_trail', '< 4.0.0'
gem 'phone'
gem 'schema_auto_foreign_keys'
gem 'schema_validations'
gem 'strip_attributes'
gem 'unf'
gem 'validates_email_format_of'

# Controller Gems
gem 'request_store'
gem 'secure_headers'
gem 'xml-sitemap'

# View Gems
gem 'bh'
gem 'haml-rails'
gem 'premailer-rails'
gem 'rails-timeago'
gem 'simple_form'
gem 'tinymce-rails'
gem 'will_paginate-bootstrap'

# Server
gem 'font_assets'
gem 'heroku-deflater'
gem 'puma'

# Monitoring
gem 'lograge'
gem 'newrelic_rpm'

group :production do
  gem 'sentry-raven'
end

group :assets, :development do
  gem 'autogrow-textarea-rails'
  gem 'autoprefixer-rails'
  gem 'bootstrap-sass'
  gem 'coffee-rails'
  gem 'font-awesome-sass'
  gem 'google-analytics-turbolinks'
  gem 'jquery-rails'
  gem 'jquery-turbolinks'
  gem 'sass-rails'
  gem 'sprockets-rails', '< 3.0.0'
  gem 'therubyracer'
  gem 'turbolinks'
  gem 'uglifier'
end

group :development, :test do
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'spring', '1.5.0'

  # Code quality tools
  gem 'brakeman', require: false
  gem 'bullet'
  gem 'bundler-audit', require: false
  gem 'cane', require: false
  gem 'coffeelint'
  gem 'haml-lint', require: false
  gem 'i18n-tasks', require: false
  gem 'immigrant'
  gem 'puppet-lint', require: false
  gem 'rails_best_practices', require: false
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'scss-lint', require: false
  gem 'simplecov', '< 0.11.0'
  gem 'simplecov-console', require: false
end

group :development do
  gem 'annotate'
  gem 'foreman'
  gem 'letter_opener_web'
  gem 'quiet_assets'
end

group :test do
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'get_process_mem'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'spring-commands-rspec'
  gem 'timecop'
  gem 'webmock'
end
