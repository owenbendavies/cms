require 'rails_helper'

RSpec.feature 'HTTPS' do
  let(:cookie) { response_headers['Set-Cookie'] }
  let(:hsts_header) { response_headers['Strict-Transport-Security'] }
  let(:csp_header) { response_headers['Content-Security-Policy'] }

  scenario 'visiting a page' do
    page.driver.header('X-Forwarded-Proto', 'https')
    visit_200_page '/home'

    expect(cookie).to include 'secure'

    expect(hsts_header).to eq 'max-age=2592000'

    expect(csp_header).to eq [
      'default-src https:',
      'img-src https: data:',
      "script-src https: 'unsafe-inline'",
      "style-src https: 'unsafe-inline'"
    ].join('; ') + ';'
  end

  scenario 'visiting a page without' do
    visit_200_page '/home'

    expect(cookie).to_not include 'secure'

    expect(hsts_header).to eq nil

    expect(csp_header).to eq [
      'default-src *',
      'img-src * data:',
      "script-src * 'unsafe-inline'",
      "style-src * 'unsafe-inline'"
    ].join('; ') + ';'
  end
end
