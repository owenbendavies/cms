Capybara.javascript_driver = :webkit

Capybara.server_port = 37_511
Capybara.default_host = 'http://localhost'
Capybara.app_host = "#{Capybara.default_host}:#{Capybara.server_port}"

Capybara::Webkit.configure do |config|
  config.skip_image_loading
  config.raise_javascript_errors = true
end
