Capybara.register_driver :chrome do |app|
  browser_options = ::Selenium::WebDriver::Chrome::Options.new
  browser_options.add_argument('--headless')
  browser_options.add_argument('--disable-gpu')
  browser_options.add_argument('--no-sandbox')
  browser_options.add_argument("--lang=#{ENV.fetch('LANGUAGE')}")
  Capybara::Selenium::Driver.new(app, browser: :chrome, capabilities: [browser_options])
end

Capybara.default_driver = :chrome
Capybara.default_host = 'http://127.0.0.1'

RSpec.configure do |config|
  config.before :each, type: :feature do
    windows.first.resize_to(1280, 800)
  end

  config.before :each, js: false do
    Capybara.current_driver = :rack_test
  end
end
