require 'rails_helper'

RSpec.describe 'Application web server' do
  context 'when visiting an html page' do
    let(:request_method) { :get }
    let(:request_path) { '/sitemap' }

    let(:random_headers) { %w[Content-Length ETag Link Set-Cookie X-Request-Id X-Runtime] }

    let(:non_random_headers) { response.headers.except(*random_headers) }

    let(:asset_src) { "'self' 'unsafe-inline' #{ENV.fetch('AWS_S3_ASSET_HOST')}" }

    let(:script_src) do
      [
        asset_src,
        'https://www.google-analytics.com',
        'https://cdnjs.cloudflare.com'
      ].join(' ')
    end

    let(:csp_header) do
      [
        "default-src 'none'",
        "child-src 'self'",
        "connect-src 'self' https://api.rollbar.com",
        "font-src 'self' https: data:",
        "img-src 'self' https: data:",
        "script-src #{script_src}",
        "style-src #{asset_src}"
      ].join('; ')
    end

    let(:expected_non_random_headers) do
      {
        'Cache-Control' => 'max-age=0, private, must-revalidate',
        'Content-Security-Policy' => csp_header,
        'Content-Type' => 'text/html; charset=utf-8',
        'Referrer-Policy' => 'strict-origin-when-cross-origin',
        'Vary' => 'Accept-Encoding',
        'X-Content-Type-Options' => 'nosniff',
        'X-Download-Options' => 'noopen',
        'X-Frame-Options' => 'DENY',
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

  context 'when visiting an asset' do
    let(:request_method) { :get }
    let(:request_path) { '/500.html' }

    before { request_page }

    it 'sets CORS allowed method' do
      expect(response.headers['Access-Control-Allow-Methods']).to eq 'get'
    end

    it 'sets CORS allowed origin' do
      expect(response.headers['Access-Control-Allow-Origin']).to eq '*'
    end

    it 'sets CORS max age' do
      expect(response.headers['Access-Control-Max-Age']).to eq '600'
    end

    it 'sets Cache Control' do
      expect(response.headers['Cache-Control']).to eq 'public, max-age=31556952'
    end
  end

  context 'with bad client' do
    let(:request_method) { :get }
    let(:request_path) { '/sitemap' }

    let(:request_headers) do
      {
        'HTTP_CLIENT_IP' => 'y',
        'HTTP_X_FORWARDED_FOR' => 'x'
      }
    end

    let(:expected_status) { 403 }

    it 'returns 403' do
      request_page
    end
  end

  context 'with gzip' do
    let(:request_method) { :get }
    let(:request_path) { '/sitemap' }
    let(:request_headers) { { 'HTTP_ACCEPT_ENCODING' => 'gzip, deflate' } }

    it 'serves pages with gzip' do
      request_page

      expect(response.headers['Content-Encoding']).to eq 'gzip'
    end
  end
end
