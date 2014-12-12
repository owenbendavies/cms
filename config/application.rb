require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
# require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Cms
  class Application < Rails::Application
    config.autoload_paths += %W(#{config.root}/lib)

    # Set Time.zone default to the specified zone and make Active Record
    # auto-convert to this zone. Run "rake -D time" for a list of tasks for
    # finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    locals = Rails.root.join('config', 'locales', '**', '*.{rb,yml}')

    config.i18n.load_path += Dir[locals]

    config.i18n.enforce_available_locales = true
    config.action_view.raise_on_missing_translations = true

    config.lograge.custom_options = lambda do |event|
      output = {
        host: event.payload[:host],
        remote_ip: event.payload[:remote_ip],
        request_id: event.payload[:request_id],
        user_agent: "\"#{event.payload[:user_agent]}\""
      }

      if event.payload[:account_id]
        output[:account_id] = event.payload[:account_id]
      end

      output
    end

    config.middleware.use Rack::Protection
  end
end
