guard :rspec, cmd: 'xvfb-run --auto-servernum ./bin/rspec' do
  require 'guard/rspec/dsl'
  dsl = Guard::RSpec::Dsl.new(self)

  rspec = dsl.rspec
  watch(rspec.spec_files)

  rails = dsl.rails(view_extensions: %w(erb haml))
  dsl.watch_spec_files_for(rails.app_files)

  watch(rails.app_controller) { "#{rspec.spec_dir}/features" }
  watch(rails.controllers) { |m| "#{rspec.spec_dir}/features/#{m[1]}" }
  watch(rails.view_dirs) { |m| "#{rspec.spec_dir}/features/#{m[1]}" }

  watch(%r{\Aapp/helpers/(.+)\.rb\z}) { |m| "#{rspec.spec_dir}/helpers/#{m[1]}" }
end
