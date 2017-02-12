require 'rails_helper'

RSpec.describe 'Application headers' do
  let(:random_headers) { %w(Content-Length ETag Set-Cookie X-Request-Id X-Runtime) }

  let(:non_random_headers) { response.headers.except(*random_headers) }

  let(:defaul_src) { "'self' 'unsafe-inline' http://localhost:37511" }

  let(:script_src) do
    [
      'script-src',
      defaul_src,
      'https://www.google-analytics.com',
      'https://d37gvrvc0wt4s1.cloudfront.net'
    ].join(' ')
  end

  let(:csp_header) do
    [
      "default-src 'none'",
      "child-src 'self'",
      "connect-src 'self' https://api.rollbar.com",
      "font-src 'self' https:",
      "img-src 'self' https: data:",
      script_src,
      "style-src #{defaul_src} https://obduk-cms-test.s3-eu-east-1.amazonaws.com"
    ].join('; ')
  end

  let(:expected_non_random_headers) do
    {
      'Cache-Control' => 'max-age=0, private, must-revalidate',
      'Content-Security-Policy' => csp_header,
      'Content-Type' => 'text/html; charset=utf-8',
      'Vary' => 'Accept-Encoding',
      'X-Content-Type-Options' => 'nosniff',
      'X-Download-Options' => 'noopen',
      'X-Frame-Options' => 'sameorigin',
      'X-Permitted-Cross-Domain-Policies' => 'none',
      'X-XSS-Protection' => '1; mode=block'
    }
  end

  let(:expected_headers) { random_headers + expected_non_random_headers.keys }

  it 'sets only expected headers' do
    request_page
    expect(response.headers.keys).to contain_exactly(*expected_headers)
  end

  it 'sets correct values for headers' do
    request_page
    expect(non_random_headers).to eq expected_non_random_headers
  end
end
