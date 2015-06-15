RSpec.configure do |config|
  if config.files_to_run.one?
    config.default_formatter = 'doc'
  else
    config.order = :random
  end

  config.disable_monkey_patching!
end
