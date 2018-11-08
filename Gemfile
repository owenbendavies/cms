source 'https://rubygems.org'
ruby '2.5.3'

gem 'rails'

# Services
gem 'aws-sdk-cognitoidentityprovider' # User management with AWS Cognito
gem 'aws-sdk-rails' # Sets up AWS SDK to work with Rails
gem 'aws-sdk-ses' # Send emails with AWS
gem 'fog-aws' # AWS file upload

# Databases
gem 'pg' # PostgreSQL
gem 'seedbank' # Better database seeds

# Frameworks
gem 'delayed_job_active_record' # Background jobs
gem 'graphql' # GraphQL API

# Rack middleware
gem 'rack-protection' # Protects against sessions attacks
gem 'rack-timeout' # Limits web request time
gem 'secure_headers' # Adds security headers to requests

# Authentication and authorization
gem 'omniauth-cognito-idp' # AWS Cognito login
gem 'pundit' # Authorization

# Model Gems
gem 'activerecord_json_validator' # JSON validation
gem 'acts_as_list' # ActiveRecord lists
gem 'carrierwave' # File upload
gem 'default_value_for' # Set default values for attributes
gem 'gravtastic' # Profile pictures
gem 'mini_magick' # Image modification
gem 'paper_trail' # Database audit
gem 'phonelib' # Phone number validation
gem 'strip_attributes' # Cleans whitespace from model fields
gem 'validates_email_format_of' # Email validation

# Controller Gems
gem 'xml-sitemap' # Generates XML site map

# View Gems
gem 'premailer-rails' # Generates txt version of emails
gem 'simple_form' # Easier forms

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
  gem 'debase' # Debugger
  gem 'dotenv-rails' # Easy environment configuration
  gem 'parallel_tests' # Run test in parallel
  gem 'pry-byebug' # Debugging
  gem 'pry-rails' # Debugging
  gem 'ruby-debug-ide' # Debugger
  gem 'solargraph' # Code completion
  gem 'spring-watcher-listen' # Quick boot
end

group :development do
  gem 'foreman', require: false # Starts multiple processes
  gem 'graphiql-rails' # GraphQL web client
  gem 'letter_opener' # Opens emails in browser
  gem 'web-console' # Web console debugger
end

group :test do
  gem 'capybara' # Web browser tester
  gem 'climate_control' # Modifies environment variables
  gem 'database_cleaner' # Cleans the database
  gem 'factory_bot_rails' # Generates test models
  gem 'faker' # Generates test data
  gem 'get_process_mem' # Gets process memory
  gem 'rspec-rails' # RSpec test framework
  gem 'rspec_junit_formatter' # Output RSpec results as XML
  gem 'selenium-webdriver' # Controls real browsers
  gem 'shoulda-matchers' # Model test helpers
  gem 'simplecov' # Code coverage
  gem 'spring-commands-rspec' # Quick boot for RSpec
  gem 'timecop' # Change time in tests
  gem 'webmock' # Mock external web requests

  # Code quality tools
  gem 'brakeman', require: false # Detect security vulnerabilities
  gem 'i18n-tasks', require: false # Detects missing translations
  gem 'jsonlint', require: false # JSON code quality
  gem 'license_finder', require: false # Whitelist of dependency licenses
  gem 'mdl', require: false # Markdown code quality
  gem 'rubocop-rspec', require: false # RSpec code quality
end
