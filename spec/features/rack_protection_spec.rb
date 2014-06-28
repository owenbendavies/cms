require 'spec_helper'

describe 'rack protection' do
  include_context 'default_site'

  it 'protects against attacks' do
    page.driver.browser.header('X_FORWARDED_FOR', 'x')
    page.driver.browser.header('CLIENT_IP', 'y')
    visit '/home'
    expect(page.status_code).to eq 403
  end
end
