if ENV['COVERAGE']
  require 'simplecov'
  require 'simplecov-console'

  SimpleCov.minimum_coverage 100

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Console,
  ]

  SimpleCov.start 'rails'

  require 'coveralls'
  Coveralls.wear!
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

require 'rspec/rails'
require 'rspec/autorun'

Dir[Rails.root.join('spec/support/**/*.rb')].each {|f| require f}

RSpec.configure do |config|
  config.before do
    if CouchPotato.couchrest_database.info['update_seq'] > 0
      CouchPotato.couchrest_database.recreate!
    end
  end
end
