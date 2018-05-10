source 'https://rubygems.org'
ruby '2.5.1'

gem 'rails'

# Services
gem 'aws-sdk-sns' # AWS SDK for SNS
gem 'fog-aws' # AWS file upload

# Databases
gem 'pg' # PostgreSQL
gem 'seedbank' # Better database seeds

# Frameworks
gem 'delayed_job_active_record' # Background jobs

# Rack middleware
gem 'rack-protection' # Protects against sessions attacks
gem 'rack-timeout' # Limits web request time
gem 'secure_headers' # Adds security headers to requests

# API
gem 'api-pagination' # Pagination for APIs
gem 'grape-route-helpers' # Named routes for APIs
gem 'grape-swagger-entity' # API docs generator
gem 'grape_logging' # API logging

# Authentication and authorization
gem 'devise_invitable' # Inviting of users
gem 'devise_zxcvbn' # Strong passwords for users
gem 'omniauth-google-oauth2' # Google login
gem 'pundit' # Authorization

# Model Gems
gem 'activerecord_json_validator' # JSON validation
gem 'acts_as_list' # ActiveRecord lists
gem 'carrierwave' # File upload
gem 'gravtastic' # Profile pictures
gem 'mini_magick' # Image modification
gem 'paper_trail' # Database audit
gem 'phonelib' # Phone number validation
gem 'strip_attributes' # Cleans whitespace from model fields
gem 'validates_email_format_of' # Email validation

# Controller Gems
gem 'xml-sitemap' # Generates XML site map

# View Gems
gem 'haml-rails' # HAML for views
gem 'premailer-rails' # Generates txt version of emails
gem 'simple_form' # Easier forms
gem 'will_paginate-bootstrap' # Pagination

# Server
gem 'bootsnap' # Fast booting
gem 'puma' # Web server

# Monitoring
gem 'lograge' # Single line logging
gem 'newrelic_rpm' # Application monitoring
gem 'rollbar' # Error notifications
gem 'scout_apm' # Application monitoring

# Assets
gem 'webpacker' # JavaScript compiler

group :development, :test do
  gem 'bullet' # Detect bad database queries
  gem 'dotenv-rails' # Easy environment configuration
  gem 'grape-swagger-rails' # API docs viewer
  gem 'pry-byebug' # Debugging
  gem 'pry-rails' # Debugging
  gem 'spring-watcher-listen' # Quick boot

  # Code quality tools
  gem 'brakeman', require: false # Detect security vulnerabilities
  gem 'bundler-audit', require: false # Checks for venerable Gems
  gem 'haml_lint', require: false # HAML code quality
  gem 'i18n-tasks', require: false # Detects missing translations
  gem 'jsonlint', require: false # JSON code quality
  gem 'license_finder', require: false # Whitelist of dependency licenses
  gem 'mdl', require: false # Markdown code quality
  gem 'rails_best_practices', require: false # Rails code quality
  gem 'rubocop-rspec', require: false # RSpec code quality
end

group :development do
  gem 'annotate', require: false # Adds comments of database schema to code
  gem 'foreman', require: false # Starts multiple processes
  gem 'web-console' # Web console debugger
end

group :test do
  gem 'capybara' # Web browser tester
  gem 'capybara_table' # Capybara table matchers
  gem 'chromedriver-helper' # Installs Google chromedriver command
  gem 'climate_control' # Modifies environment variables
  gem 'database_cleaner' # Cleans the database
  gem 'factory_bot_rails' # Generates test models
  gem 'faker' # Generates test data
  gem 'get_process_mem' # Gets process memory
  gem 'rspec-rails' # RSpec test framework
  gem 'selenium-webdriver' # Controls real browsers
  gem 'shoulda-matchers' # Model test helpers
  gem 'simplecov' # Code coverage
  gem 'spring-commands-rspec' # Quick boot for RSpec
  gem 'timecop' # Change time in tests
  gem 'webmock' # Mock external web requests
end
