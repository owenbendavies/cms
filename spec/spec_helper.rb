RSpec.configure do |config|
  if config.files_to_run.one?
    config.default_formatter = 'doc'
  else
    config.order = :random
    config.profile_examples = 10
  end

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end
end
