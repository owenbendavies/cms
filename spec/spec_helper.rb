all_files = Dir[File.expand_path('../**/*.rb', __FILE__)]

good_files = Dir[
  File.expand_path('../support/**/*.rb', __FILE__),
  File.expand_path('../factories/**/*.rb', __FILE__),
  File.expand_path('../**/*_spec.rb', __FILE__),
  File.expand_path('../rails_helper.rb', __FILE__),
  __FILE__
]

bad_files = all_files - good_files

if bad_files.any?
  fail "The following files should be named _spec.rb #{bad_files}"
end

RSpec.configure do |config|
  if config.files_to_run.one?
    config.default_formatter = 'doc'
  else
    config.order = :random
  end

  config.disable_monkey_patching!
end
