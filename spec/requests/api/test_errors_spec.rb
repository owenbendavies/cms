require 'rails_helper'

RSpec.describe 'API Test Errors' do
  let(:request_user) { FactoryBot.create(:user, :sysadmin) }

  context 'with GET /api/test_errors/500' do
    let(:expected_body) do
      {
        'error' => 'Internal server error',
        'message' => 'Sorry, something unexpected has gone wrong',
        'errors' => {}
      }
    end

    let(:expected_status) { 500 }

    include_examples(
      'swagger documentation',
      description: 'Creates a test 500 error',
      model: 'SystemError'
    )

    it 'returns 500 error' do
      request_page
      expect(json_body).to eq expected_body
    end

    it 'logs error to rollbar' do
      expect(Rollbar).to receive(:error).with(RuntimeError).and_call_original
      request_page
    end
  end

  context 'with GET /api/test_errors/delayed' do
    let(:expected_status) { 202 }

    include_examples(
      'swagger documentation',
      description: 'Creates a test background job error',
      model: 'SystemMessage'
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
      description: 'Creates a test timeout error',
      model: nil
    )

    it 'raises timeout error' do
      expect { request_page }.to raise_error Rack::Timeout::RequestTimeoutError
    end
  end
end
