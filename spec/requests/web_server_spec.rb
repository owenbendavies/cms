require 'rails_helper'

RSpec.describe 'Application web server' do
  include_context 'with headers'

  let(:request_method) { :get }
  let(:request_path) { '/sitemap' }

  shared_examples 'asset headers' do
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
      expect(response.headers['Cache-Control']).to eq "public, max-age=#{1.year.to_i}"
    end
  end

  context 'when visiting an html page' do
    include_examples 'sets headers' do
      let(:expected_content_type) { 'text/html; charset=utf-8' }
    end
  end

  context 'when visiting a asset' do
    let(:request_path) do
      Dir
        .glob(Rails.root.join('public', '*', 'application-*.js'))
        .first
        .gsub(Rails.root.join('public').to_s, '')
    end

    include_examples 'asset headers'
  end

  context 'with bad client' do
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
    let(:request_headers) { { 'HTTP_ACCEPT_ENCODING' => 'gzip, deflate' } }

    context 'when visiting a page' do
      it 'serves pages with gzip' do
        request_page

        expect(response.headers['Content-Encoding']).to eq 'gzip'
      end
    end

    context 'when visiting an asset' do
      let(:request_path) do
        asset_file_path = Dir.glob(Rails.root.join('public', 'packs', 'stylesheet*.css')).first
        asset_file_path.gsub(Rails.root.join('public').to_s, '')
      end

      it 'serves assets with gzip' do
        request_page

        expect(response.headers['Content-Encoding']).to eq 'gzip'
      end
    end
  end
end
