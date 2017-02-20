require 'rails_helper'

RSpec.describe 'Robots' do
  context 'GET /robots.txt' do
    let(:expected_body) do
      <<EOF
Sitemap: http://#{site.host}/sitemap.xml

User-agent: *
Disallow:
EOF
    end

    it 'renders robots file' do
      request_page

      expect(body).to eq expected_body
    end

    it 'has txt type' do
      request_page

      expect(response.headers['Content-Type']).to eq 'text/plain; charset=utf-8'
    end
  end

  context 'GET /robots' do
    include_context 'renders page not found'
  end

  context 'GET /robots.xml' do
    include_context 'returns 406'
  end
end
