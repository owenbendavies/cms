require 'rails_helper'

RSpec.feature 'HTTPS' do
  let(:cookie) { response_headers['Set-Cookie'] }
  let(:hsts_header) { response_headers['Strict-Transport-Security'] }

  scenario 'visiting a page' do
    page.driver.header('X-Forwarded-Proto', 'https')
    visit_200_page '/home'

    expect(cookie).to include 'secure'
    expect(hsts_header).to be_nil
  end

  scenario 'visiting a page without' do
    visit_200_page '/home'

    expect(cookie).to_not include 'secure'
    expect(hsts_header).to be_nil
  end
end
