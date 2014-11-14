require 'rails_helper'

RSpec.describe 'rack protection', type: :feature do
  it 'protects against attacks' do
    page.driver.browser.header('X_FORWARDED_FOR', 'x')
    page.driver.browser.header('CLIENT_IP', 'y')
    visit '/home'
    expect(page.status_code).to eq 403
  end
end
