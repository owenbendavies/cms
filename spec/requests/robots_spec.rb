require 'rails_helper'

RSpec.describe 'Robots' do
  context 'with GET /robots.txt' do
    let(:expected_body) do
      <<~FILE
        Sitemap: http://#{site.host}/sitemap.xml

        User-agent: *
        Disallow:
      FILE
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

  context 'with GET /robots' do
    include_examples 'renders html page not found'
  end

  context 'with GET /robots.xml' do
    include_examples 'returns 406'
  end
end
