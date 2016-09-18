source 'https://rubygems.org'
ruby '2.3.1'

# Frameworks
gem 'rails', '4.2.7.1' # LOCKED as recent version has dependency conflicts
gem 'delayed_job_active_record' # Background jobs

# Databases
gem 'pg' # PostgreSQL

# Rack middleware
gem 'rack-protection' # Protects against sessions attacks
gem 'rack-timeout' # Limits web request time
gem 'secure_headers' # Adds security headers to requests

# Authentication and authorization
gem 'devise_invitable' # Inviting of users
gem 'devise_zxcvbn', '2.1.1' # Strong passwords for users (LOCKED as 2.1.2 is broken)
gem 'omniauth-google-oauth2' # Google login
gem 'pundit' # Authorization

# Model Gems
gem 'acts_as_list' # ActiveRecord lists
gem 'carrierwave', '0.11.0' # File upload (LOCKED as 0.11.2 leaks files)
gem 'fog' # Remote file upload
gem 'gravtastic' # Profile pictures
gem 'mini_magick' # Image modification
gem 'paper_trail', '< 5.0.0' # Database audit (LOCKED as 5.2.0 is broken)
gem 'phone' # Phone number validation
gem 'schema_associations' # Automatically adds ActiveRecord relations
gem 'schema_auto_foreign_keys' # Automatically adds foreign keys to migrations
gem 'schema_validations' # Automatically adds ActiveRecord validations from database schema
gem 'strip_attributes' # Cleans whitespace from model fields
gem 'validates_email_format_of' # Email validation

# Controller Gems
gem 'xml-sitemap' # Generates XML site map

# View Gems
gem 'haml-rails' # HAML for views
gem 'premailer-rails' # Generates txt version of emails
gem 'rails-timeago' # Nice time tags
gem 'simple_form' # Easier forms
gem 'tinymce-rails' # Rich text editor
gem 'will_paginate-bootstrap' # Pagination

# Server
gem 'font_assets' # Serves fonts with correct CORS headers
gem 'heroku-deflater' # Serves gzip assets
gem 'puma' # Web server

# Monitoring
gem 'lograge' # Single line logging
gem 'newrelic_rpm' # Performance monitoring
gem 'rollbar' # Error notifications

group :assets, :development do
  gem 'bower-rails' # Manage asset dependencies
  gem 'coffee-rails' # CoffeeScript for JavaScript
  gem 'font-awesome-sass' # Icons
  gem 'google-analytics-turbolinks' # Make Google Analytics work for TurboLinks
  gem 'sass-rails' # Sass for stylesheets
  gem 'sprockets-rails', '3.1.1' # Manages asset files (LOCKED as 3.2.0 is broken)
  gem 'turbolinks' # JavaScript switching between pages
  gem 'uglifier' # JavaScript compression
end

group :development, :test do
  gem 'dotenv-rails' # Easy environment configuration
  gem 'guard' # Automatic test runner
  gem 'guard-rspec', require: false # RSpec additions to guard
  gem 'pry-byebug' # Debugging
  gem 'pry-rails' # Debugging
  gem 'spring' # Quick boot

  # Code quality tools
  gem 'brakeman', require: false # Detect security vulnerabilities
  gem 'bullet', '5.2.0' # Detect bad database queries (LOCKED as requires changes)
  gem 'cane', require: false # Ruby code quality
  gem 'coffeelint' # CoffeeScript code quality
  gem 'haml_lint', require: false # HAML code quality
  gem 'i18n-tasks', require: false # Detects missing translations
  gem 'immigrant' # Detects missing database foreign keys
  gem 'rails_best_practices', require: false # Rails code quality
  gem 'rubocop-rspec', '1.5.1', require: false # RSpect code quality (LOCKED as requires changes)
  gem 'scss_lint', require: false # Sass code quality
  gem 'simplecov', '< 0.11.0' # Code coverage (LOCKED as 0.12.0 is broken)
end

group :development do
  gem 'annotate' # Adds comments of database schema to code
  gem 'foreman' # Starts multiple processes
  gem 'letter_opener_web' # Email client
end

group :test do
  gem 'capybara-webkit' # Web browser tester
  gem 'climate_control' # Modifies environment variables
  gem 'database_cleaner' # Cleans the database
  gem 'factory_girl_rails' # Generates test models
  gem 'faker' # Generates test data
  gem 'get_process_mem' # Gets process memory
  gem 'rspec-rails' # RSpec test framework
  gem 'shoulda-matchers' # Model test helpers
  gem 'spring-commands-rspec' # Quick boot for RSpec
  gem 'timecop' # Change time in tests
  gem 'webmock' # Mock external web requests
end
