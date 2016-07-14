source 'https://rubygems.org'
ruby '2.3.1'

# Frameworks
gem 'rails', '4.2.7'
gem 'delayed_job_active_record' # Background jobs

# Databases
gem 'pg' # PostgreSQL

# Rack middleware
gem 'rack-protection' # Protects against sessions attacks
gem 'rack-timeout' # Limits web request time
gem 'secure_headers' # Adds security headers to requests

# Authentication and authorization
gem 'devise_invitable' # Inviting of users
gem 'devise_zxcvbn' # Strong passwords for users
gem 'omniauth-google-oauth2' # Google login
gem 'pundit' # Authorization

# Model Gems
gem 'acts_as_list' # ActiveRecord lists
gem 'carrierwave', '0.11.0' # File upload
gem 'fog' # Remote file upload
gem 'gravtastic' # Profile pictures
gem 'mini_magick' # Image modification
gem 'paper_trail', '< 5.0.0' # Database audit
gem 'phone' # Phone number validation
gem 'schema_associations' # Automatically adds ActiveRecord relations
gem 'schema_auto_foreign_keys' # Automatically adds foreign keys to migrations
gem 'schema_validations' # Automatically adds ActiveRecord validations from database schema
gem 'strip_attributes' # Cleans whitespace from model fields
gem 'validates_email_format_of' # Email validation

# Controller Gems
gem 'xml-sitemap' # Generates XML site map

# View Gems
gem 'simple_form' # Easier forms (require before bh)
gem 'bh' # Bootstrap helpers
gem 'haml-rails' # HAML for views
gem 'premailer-rails' # Generates txt version of emails
gem 'rails-timeago' # Nice time tags
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
  gem 'autogrow-textarea-rails' # JavaScript expanding textarea
  gem 'bootstrap-sass' # Bootstrap
  gem 'coffee-rails' # CoffeeScript for JavaScript
  gem 'font-awesome-sass' # Icons
  gem 'google-analytics-turbolinks' # Make Google Analytics work for TurboLinks
  gem 'jquery-rails' # Add jQuery
  gem 'jquery-turbolinks' # Make jQuery work for TurboLinks
  gem 'sass-rails' # Sass for stylesheets
  gem 'therubyracer' # JavaScript compilation
  gem 'turbolinks', '< 5.0.0' # JavaScript switching between pages
  gem 'uglifier' # JavaScript compression
end

group :development, :test do
  gem 'dotenv-rails' # Easy environment configuration
  gem 'pry-byebug' # Debugging
  gem 'pry-rails' # Debugging
  gem 'spring' # Quick boot

  # Code quality tools
  gem 'brakeman', require: false # Detect security vulnerabilities
  gem 'bullet' # Detect n+1 database queries
  gem 'cane', require: false # Ruby code quality
  gem 'coffeelint' # CoffeeScript code quality
  gem 'haml_lint', require: false # HAML code quality
  gem 'i18n-tasks', require: false # Detects missing translations
  gem 'immigrant' # Detects missing database foreign keys
  gem 'rails_best_practices', require: false # Rails code quality
  gem 'rubocop-rspec', require: false # RSpect code quality
  gem 'scss-lint', require: false # Sass code quality
  gem 'simplecov', '< 0.11.0' # Code coverage
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
