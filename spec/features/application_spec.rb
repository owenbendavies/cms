require 'rails_helper'

RSpec.describe 'application', type: :feature do
  it 'redirects root path to home' do
    visit '/'
    expect(current_path).to eq '/home'
  end

  it 'protects against attacks' do
    page.driver.header('X_FORWARDED_FOR', 'x')
    page.driver.header('CLIENT_IP', 'y')
    visit '/home'
    expect(page.status_code).to eq 403
  end

  it 'stores session data in database' do
    visit_page '/home'
    expect(response_headers['Set-Cookie'])
      .to match(/^_cms_session=[0-9a-f]{32};.*/)
  end
end
