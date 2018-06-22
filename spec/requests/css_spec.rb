require 'rails_helper'

RSpec.describe 'CSS' do
  context 'with GET /css/:id-xxx.css' do
    let!(:site) { FactoryBot.create(:site) }
    let(:request_host) { new_host }
    let(:request_path_id) { site.uid }

    context 'with stylesheet' do
      let!(:stylesheet) { FactoryBot.create(:stylesheet, site: site) }

      before do
        request_page
      end

      it 'renders css' do
        expect(response.body).to eq stylesheet.css
      end

      it 'returns css content type' do
        expect(response.content_type).to eq 'text/css'
      end

      it 'caches the page' do
        expect(response.cache_control).to eq(max_age: '31556952', public: true)
      end
    end

    context 'without stylesheet' do
      include_examples 'returns 406'
    end
  end
end
