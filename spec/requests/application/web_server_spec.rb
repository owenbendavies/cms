require 'rails_helper'

RSpec.describe 'Application web server' do
  context 'visiting a font' do
    let(:request_path) do
      font_path = Dir.glob(Rails.root.join('public', 'assets', '**', '*.woff')).first
      font_path.gsub(Rails.root.join('public').to_s, '')
    end

    it 'sets CORS headers' do
      request_page

      expect(response.headers['Access-Control-Allow-Origin']).to eq '*'
    end
  end

  context 'with a bad client' do
    let(:request_headers) do
      {
        'HTTP_CLIENT_IP' => 'y',
        'HTTP_X_FORWARDED_FOR' => 'x'
      }
    end

    it 'returns 403' do
      request_page(expected_status: 403)
    end
  end

  context 'with gzip' do
    let(:request_headers) { { 'HTTP_ACCEPT_ENCODING' => 'gzip, deflate' } }

    context 'visiting a page' do
      it 'serves pages with gzip' do
        request_page

        expect(response.headers['Content-Encoding']).to eq 'gzip'
      end
    end

    context 'visiting an asset' do
      let(:request_path) do
        asset_file_path = Dir.glob(Rails.root.join('public', 'assets', 'application*.css')).first
        asset_file_path.gsub(Rails.root.join('public').to_s, '')
      end

      it 'serves assets with gzip' do
        request_page

        expect(response.headers['Content-Encoding']).to eq 'gzip'
      end
    end
  end
end
