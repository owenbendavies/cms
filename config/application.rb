require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
# require 'action_cable/engine'
require 'sprockets/railtie'
# require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Cms
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # Raises error for missing translations
    config.action_view.raise_on_missing_translations = true
    config.i18n.enforce_available_locales = true

    if ENV['ASSET_HOST']
      # Enable serving of images, stylesheets, and JavaScripts from an asset server.
      config.action_controller.asset_host = ENV['ASSET_HOST']
    end

    # Lograge options
    config.lograge.custom_options = lambda do |event|
      {
        host: event.payload[:host],
        request_id: event.payload[:request_id],
        fwd: event.payload[:fwd],
        user_id: event.payload[:user_id],
        user_agent: event.payload[:user_agent].inspect
      }
    end

    # Customer middleware
    config.middleware.use Rack::Deflater
    config.middleware.use Rack::Protection

    config.active_job.queue_adapter = :delayed_job
  end
end
