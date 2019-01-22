ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

unless ENV['DISABLE_BOOTSNAP'] == 'true'
  require 'bootsnap/setup' # Speed up boot time by caching expensive operations.
end
