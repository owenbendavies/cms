require 'rails_helper'

RSpec.describe 'API System' do
  context 'with GET /api/system/health' do
    let(:request_host) { new_host }

    include_examples(
      'swagger documentation',
      description: 'Returns the health of the system',
      model: 'SystemHealth'
    )

    it 'renders ok' do
      request_page

      expect(json_body).to eq('all' => true)
    end
  end

  context 'with GET /api/system/test_500_error' do
    let(:request_user) { FactoryBot.create(:user, :sysadmin) }

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

  context 'with GET /api/system/test_delayed_error' do
    let(:request_user) { FactoryBot.create(:user, :sysadmin) }

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

  context 'with GET /api/system/test_timeout_error' do
    let(:request_user) { FactoryBot.create(:user, :sysadmin) }

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
