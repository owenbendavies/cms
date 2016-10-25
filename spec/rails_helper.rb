if ENV['COVERAGE']
  require 'simplecov'

  SimpleCov.minimum_coverage 100
  SimpleCov.start 'rails'
end

ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!
