Capybara.register_driver :chrome do |app|
  browser_options = ::Selenium::WebDriver::Chrome::Options.new
  browser_options.args << '--headless'
  browser_options.args << '--disable-gpu'
  browser_options.args << '--no-sandbox'
  browser_options.args << "--lang=#{ENV.fetch('LANGUAGE')}"
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
end

Capybara.default_driver = :chrome
Capybara.server_port = Integer(ENV.fetch('EMAIL_LINK_PORT'))
Capybara.default_host = 'http://localhost'
Capybara.app_host = "#{Capybara.default_host}:#{Capybara.server_port}"

RSpec.configure do |config|
  config.before :each, type: :feature do
    windows.first.resize_to(1280, 800)
  end

  config.before :each, js: false do
    Capybara.current_driver = :rack_test
  end
end
