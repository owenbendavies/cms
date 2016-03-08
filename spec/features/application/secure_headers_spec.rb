require 'rails_helper'

RSpec.feature 'Secure Headers' do
  let(:header) { |example| response_headers[example.description] }

  before do
    page.driver.header('X-Forwarded-Proto', 'https')
    visit_200_page '/home'
  end

  scenario 'Content-Security-Policy' do
    expect(header).to eq [
      "default-src 'none'",
      "connect-src 'self'",
      "font-src 'self' https:",
      "img-src 'self' https: data:",
      "script-src 'self' https: 'unsafe-inline'",
      "style-src 'self' https: 'unsafe-inline'"
    ].join('; ')
  end

  scenario 'Strict-Transport-Security' do
    expect(header).to be_nil
  end

  scenario 'X-Frame-Options' do
    expect(header).to eq 'sameorigin'
  end

  scenario 'X-XSS-Protection' do
    expect(header).to eq '1; mode=block'
  end

  scenario 'X-Content-Type-Options' do
    expect(header).to eq 'nosniff'
  end

  scenario 'X-Download-Options' do
    expect(header).to eq 'noopen'
  end

  scenario 'X-Permitted-Cross-Domain-Policies' do
    expect(header).to eq 'none'
  end
end
