RSpec.configure do |config|
  config.before :each, js: true do
    page.driver.block_unknown_urls
  end
end

Capybara.javascript_driver = :webkit

Capybara.server_port = 37_511
Capybara.default_host = 'http://localhost'
Capybara.app_host = "#{Capybara.default_host}:#{Capybara.server_port}"
