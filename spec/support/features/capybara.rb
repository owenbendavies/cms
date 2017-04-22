Capybara.default_driver = :webkit
Capybara.server_port = 37_511
Capybara.default_host = 'http://localhost'
Capybara.app_host = "#{Capybara.default_host}:#{Capybara.server_port}"

Capybara::Webkit.configure do |config|
  config.raise_javascript_errors = true

  config.block_url(CarrierWave::Uploader::Base.asset_host)
  config.block_url('https://secure.gravatar.com')
  config.block_url('https://www.google-analytics.com')
end

RSpec.configure do |config|
  config.before :each, js: false do
    Capybara.current_driver = :rack_test
  end
end
