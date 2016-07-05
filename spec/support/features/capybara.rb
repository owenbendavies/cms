Capybara.javascript_driver = :webkit

Capybara.server_port = 37_511
Capybara.default_host = 'http://localhost'
Capybara.app_host = "#{Capybara.default_host}:#{Capybara.server_port}"

Capybara::Webkit.configure(&:skip_image_loading)

RSpec.shared_context 'check js errors', js: true do
  after do
    expect(page.driver.error_messages).to eq []
  end
end
