source 'https://rubygems.org'
ruby '2.3.3'

gem 'rails'

# Databases
gem 'pg' # PostgreSQL

# Frameworks
gem 'delayed_job_active_record' # Background jobs

# Rack middleware
gem 'rack-protection' # Protects against sessions attacks
gem 'rack-timeout' # Limits web request time
gem 'secure_headers' # Adds security headers to requests

# Authentication and authorization
gem 'devise_invitable' # Inviting of users
gem 'devise_zxcvbn', '2.1.1' # TODO: Upgrade when 2.1.2 is fixed - Strong passwords for users
gem 'omniauth-google-oauth2' # Google login
gem 'pundit' # Authorization

# Remote file upload (before carrierwave)
gem 'fog-aws' # AWS file upload

# Model Gems
gem 'acts_as_list' # ActiveRecord lists
gem 'carrierwave' # File upload
gem 'gravtastic' # Profile pictures
gem 'mini_magick' # Image modification
gem 'paper_trail' # Database audit
gem 'phonelib' # Phone number validation
gem 'schema_associations' # Automatically adds ActiveRecord relations
gem 'schema_auto_foreign_keys' # Automatically adds foreign keys to migrations
gem 'schema_validations' # Automatically adds ActiveRecord validations from database schema
gem 'strip_attributes' # Cleans whitespace from model fields
gem 'validates_email_format_of' # Email validation
gem 'validate_url' # URL validation

# Controller Gems
gem 'xml-sitemap' # Generates XML site map

# View Gems
gem 'haml-rails' # HAML for views
gem 'premailer-rails' # Generates txt version of emails
gem 'rails-timeago' # Nice time tags
gem 'simple_form' # Easier forms
gem 'tinymce-rails', '4.5.1' # TODO: Upgrade when 4.5.2 is fixed - Rich text editor
gem 'will_paginate-bootstrap' # Pagination

# Server
gem 'delayed_job_worker_pool' # Multiple delayed jobs
gem 'font_assets' # Serves fonts with correct CORS headers
gem 'puma' # Web server

# Monitoring
gem 'lograge' # Single line logging
gem 'newrelic_rpm' # Performance monitoring
gem 'rollbar' # Error notifications

group :assets, :development do
  gem 'autosize-rails' # JavaScript expanding textarea
  gem 'bootstrap-sass' # CSS framework
  gem 'coffee-rails' # CoffeeScript for JavaScript
  gem 'font-awesome-sass' # Icons
  gem 'google-analytics-turbolinks' # Make Google Analytics work for TurboLinks
  gem 'jquery-rails' # jQuery
  gem 'sass-rails' # Sass for stylesheets
  gem 'turbolinks' # JavaScript switching between pages
  gem 'uglifier' # JavaScript compression
end

group :development, :test do
  gem 'bullet' # Detect bad database queries
  gem 'dotenv-rails' # Easy environment configuration
  gem 'pry-byebug' # Debugging
  gem 'pry-rails' # Debugging
  gem 'spring' # Quick boot

  # Code quality tools
  gem 'brakeman', require: false # Detect security vulnerabilities
  gem 'coffeelint' # CoffeeScript code quality
  gem 'haml_lint', require: false # HAML code quality
  gem 'i18n-tasks', require: false # Detects missing translations
  gem 'jsonlint', require: false # JSON code quality
  gem 'mdl', require: false # Markdown code quality
  gem 'rails_best_practices', require: false # Rails code quality
  gem 'rubocop-rspec', require: false # RSpec code quality
  gem 'scss_lint', require: false # Sass code quality
end

group :development do
  gem 'annotate', require: false # Adds comments of database schema to code
  gem 'foreman', require: false # Starts multiple processes
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
  gem 'simplecov' # Code coverage
  gem 'spring-commands-rspec' # Quick boot for RSpec
  gem 'timecop' # Change time in tests
  gem 'webmock' # Mock external web requests
end
