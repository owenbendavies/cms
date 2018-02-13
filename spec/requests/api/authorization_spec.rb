require 'rails_helper'

RSpec.describe 'API Authorization' do
  shared_examples 'renders forbidden' do
    let(:expected_body) do
      {
        'error' => 'Forbidden',
        'message' => 'Either you do not have permission or the resource was not found'
      }
    end

    it 'renders forbidden' do
      request_page(expected_status: 403)

      expect(json_body).to eq(expected_body)
    end
  end

  context 'with an unauthorized user' do
    let(:request_method) { :get }
    let(:request_path) { '/api/messages' }
    let(:request_user) { FactoryBot.create(:user) }

    include_examples 'renders forbidden'
  end

  context 'with missing record' do
    let(:request_method) { :get }
    let(:request_path) { '/api/messages/badmessage' }

    include_examples 'renders forbidden'
  end
end
