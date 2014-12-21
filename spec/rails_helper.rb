if ENV['COVERAGE']
  require 'simplecov'
  require 'simplecov-console'
  require 'coveralls'

  SimpleCov.minimum_coverage 100

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Console,
    Coveralls::SimpleCov::Formatter,
  ]

  SimpleCov.start 'rails'
end

ENV['RAILS_ENV'] ||= 'test'
require 'rails_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'shoulda/matchers'
require 'paper_trail/frameworks/rspec'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.before :all do
    DatabaseCleaner.clean_with :truncation
    DatabaseCleaner.strategy = :transaction
  end

  config.before :each, js: true do
    DatabaseCleaner.strategy = :truncation
  end

  config.before :each do
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end
end
