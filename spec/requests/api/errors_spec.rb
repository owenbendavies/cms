require 'rails_helper'

RSpec.describe 'API Errors' do
  let(:user) { FactoryBot.create(:user, :sysadmin) }

  context 'with GET /api/errors/500' do
    it 'raises 500 error' do
      expect { request_page }.to raise_error(RuntimeError, 'Test 500 error')
    end
  end

  context 'with GET /api/errors/delayed' do
    before { request_page }

    after { Delayed::Job.last.destroy! }

    it 'renders message' do
      expect(json_body).to eq('message' => 'Delayed error sent')
    end

    it 'raises error for delayed job' do
      expect { Delayed::Job.last.invoke_job }.to raise_error(RuntimeError, 'Test delayed error')
    end
  end

  context 'with GET /api/errors/timeout' do
    it 'raises timeout error' do
      expect { request_page }.to raise_error Rack::Timeout::RequestTimeoutError
    end
  end
end
