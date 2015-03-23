RSpec.configure do |config|
  config.before :all do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  config.before :each do
    DatabaseCleaner.clean
  end
end
