require 'rails_helper'

RSpec.describe 'CSS' do
  context 'with GET /css/xxx.css' do
    let(:request_path_id) { site.id }

    context 'with stylesheet' do
      let(:site) { create(:site) }

      before do
        request_page
      end

      it 'renders css' do
        expect(response.body).to eq site.css
      end

      it 'returns css content type' do
        expect(response.content_type).to eq 'text/css; charset=utf-8'
      end

      it 'caches the page' do
        expect(response.cache_control).to eq(max_age: '31556952', public: true)
      end
    end

    context 'without stylesheet' do
      let(:site) { create(:site, css: nil) }
      let(:expected_status) { 404 }

      it 'returns empty 404' do
        request_page
        expect(body).to be_empty
      end
    end
  end
end
