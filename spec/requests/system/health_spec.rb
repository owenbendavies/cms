require 'rails_helper'

RSpec.describe 'Health check' do
  shared_examples 'renders health check' do
    context 'GET /system/health.txt' do
      it 'renders ok' do
        request_page

        expect(body).to eq 'ok'
      end

      it 'has txt type' do
        request_page

        expect(response.headers['Content-Type']).to eq 'text/plain; charset=utf-8'
      end
    end

    context 'GET /system/health.xml' do
      include_examples 'returns 406'
    end
  end

  context 'known site' do
    include_examples 'renders health check'
  end

  context 'unknown site' do
    let(:request_host) { new_host }

    include_examples 'renders health check'
  end
end
