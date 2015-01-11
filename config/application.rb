require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Cms
  class Application < Rails::Application
    locals = Rails.root.join('config', 'locales', '**', '*.{rb,yml}')
    config.i18n.load_path += Dir[locals]

    config.i18n.enforce_available_locales = true
    config.action_view.raise_on_missing_translations = true

    config.active_record.raise_in_transactional_callbacks = true

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
