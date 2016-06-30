source 'https://rubygems.org'
ruby '2.3.1'

# Frameworks
gem 'rails'
gem 'delayed_job_active_record'

# Databases
gem 'pg'

# Rack middleware
gem 'rack-protection'
gem 'rack-timeout'
gem 'secure_headers'

# Authentication and authorization
gem 'devise_invitable'
gem 'devise_zxcvbn'
gem 'omniauth-google-oauth2'
gem 'pundit'

# Model Gems
gem 'acts_as_list'
gem 'carrierwave', '0.11.0'
gem 'fog'
gem 'gravtastic'
gem 'mini_magick'
gem 'paper_trail', '< 5.0.0'
gem 'phone'
gem 'schema_associations'
gem 'schema_auto_foreign_keys'
gem 'schema_validations'
gem 'strip_attributes'
gem 'validates_email_format_of'

# Controller Gems
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
gem 'rollbar'

group :assets, :development do
  gem 'autogrow-textarea-rails'
  gem 'bootstrap-sass'
  gem 'coffee-rails'
  gem 'font-awesome-sass'
  gem 'google-analytics-turbolinks'
  gem 'jquery-rails'
  gem 'jquery-turbolinks'
  gem 'sass-rails'
  gem 'sprockets', '3.6.0'
  gem 'therubyracer'
  gem 'turbolinks'
  gem 'uglifier'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'spring'

  # Code quality tools
  gem 'brakeman', require: false
  gem 'bullet'
  gem 'cane', require: false
  gem 'coffeelint'
  gem 'haml_lint', require: false
  gem 'i18n-tasks', require: false
  gem 'immigrant'
  gem 'rails_best_practices', require: false
  gem 'rubocop-rspec', require: false
  gem 'scss-lint', require: false
  gem 'simplecov', '< 0.11.0'
  gem 'simplecov-console', require: false
end

group :development do
  gem 'annotate'
  gem 'foreman'
  gem 'letter_opener_web'
end

group :test do
  gem 'capybara-webkit'
  gem 'climate_control'
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
