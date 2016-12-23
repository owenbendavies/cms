require 'rails_helper'

RSpec.feature 'Secure Headers' do
  let(:header) { |example| response_headers[example.description] }

  before do
    page.driver.header('X-Forwarded-Proto', 'https')
    visit_200_page '/home'
  end

  scenario 'Content-Security-Policy' do
    defaul_src = "'self' 'unsafe-inline' http://localhost:37511"

    script_src = [
      'script-src',
      defaul_src,
      'https://www.google-analytics.com',
      'https://d37gvrvc0wt4s1.cloudfront.net'
    ].join(' ')

    expect(header).to eq [
      "default-src 'none'",
      "child-src 'self'",
      "connect-src 'self' https://api.rollbar.com",
      "font-src 'self' https:",
      "img-src 'self' https: data:",
      script_src,
      "style-src #{defaul_src} https://obduk-cms-test.s3-eu-east-1.amazonaws.com"
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
