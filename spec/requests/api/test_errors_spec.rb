require 'rails_helper'

RSpec.describe 'API Test Errors' do
  let(:request_user) { FactoryBot.create(:user, :sysadmin) }

  context 'with GET /api/test_errors/500' do
    include_examples(
      'swagger documentation',
      description: 'Creates a test 500 error'
    )

    it 'raises 500 error' do
      expect { request_page }.to raise_error(RuntimeError, 'Test 500 error')
    end
  end

  context 'with GET /api/test_errors/delayed' do
    include_examples(
      'swagger documentation',
      description: 'Creates a test background job error'
    )

    before { request_page }

    after { Delayed::Job.last.destroy! }

    it 'renders message' do
      expect(json_body).to eq('message' => 'Delayed error sent')
    end

    it 'raises error for delayed job' do
      expect { Delayed::Job.last.invoke_job }.to raise_error(RuntimeError, 'Test delayed error')
    end
  end

  context 'with GET /api/test_errors/timeout' do
    include_examples(
      'swagger documentation',
      description: 'Creates a test timeout error'
    )

    it 'raises timeout error' do
      expect { request_page }.to raise_error Rack::Timeout::RequestTimeoutError
    end
  end
end
