require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
# require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
# require 'action_mailbox/engine'
# require 'action_text/engine'
require 'action_view/railtie'
# require 'action_cable/engine'
require 'sprockets/railtie' if Rails.env.development?
# require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Cms
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults '6.0'

    config.generators do |generator|
      generator.orm :active_record, primary_key_type: :uuid
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config/locales/**/*.{rb,yml}').to_s]

    # Raises error for missing translations
    config.i18n.raise_on_missing_translations = true

    unless ENV['DISABLE_SSL']
      # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
      config.force_ssl = true
    end

    # Logging
    if ENV['RAILS_LOG_TO_STDOUT'].present?
      config.colorize_logging = false
      config.log_level = :info
      config.logger = LogStashLogger.new(type: :stdout)

      config.logstasher.logger = Logger.new($stdout)
      config.logstasher.suppress_app_log = true

      config.middleware.delete(ActionDispatch::DebugExceptions)
    end

    config.logstasher.backtrace = false
    config.logstasher.enabled = true
    config.logstasher.view_enabled = false

    config.logstasher.field_renaming = {
      ip: :fwd
    }

    LogStasher.add_custom_fields_to_request_context do |fields|
      fields[:cf_ray] = request.headers['CF-RAY']
      fields[:country] = request.headers['CF-IPCountry']
      fields[:host] = request.host
      fields[:user_id] = try(:current_user)&.id
      fields[:user_agent] = request.user_agent
    end

    config.log_tags = %i[host remote_ip request_id]

    LogStashLogger.configure do |config|
      config.customize_event do |event|
        event['host'], event['fwd'], event['request_id'] = event['tags']
        event['tags'] = ['rails']
      end
    end

    # Customer middleware
    config.middleware.use Rack::Deflater
    config.middleware.use Rack::Protection
  end
end
