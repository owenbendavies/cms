require 'rails_helper'

RSpec.describe 'API errors' do
  shared_examples 'renders bad request' do |expected_messages|
    let(:expected_body) do
      {
        'error' => 'Bad request',
        'message' => 'Invalid parameters',
        'errors' => expected_messages
      }
    end

    it 'renders bad request' do
      request_page(expected_status: 400)

      expect(json_body).to eq(expected_body)
    end
  end

  context 'with invalid parameters' do
    let(:request_method) { :get }
    let(:request_path) { '/api/messages?per_page=bad' }

    include_examples 'renders bad request', 'per_page' => ['is invalid']
  end

  context 'with missing parameters' do
    let(:request_method) { :post }
    let(:request_path) { '/api/messages' }

    let(:request_params) do
      {
        'name' => new_name
      }
    end

    include_examples 'renders bad request', 'email' => ['is missing'], 'message' => ['is missing']
  end

  context 'with invalid model parameters' do
    let(:request_method) { :post }
    let(:request_path) { '/api/messages' }

    let(:request_params) do
      {
        'name' => new_name,
        'email' => 'bad email',
        'phone' => 'bad phone number',
        'message' => new_message
      }
    end

    let(:expected_body) do
      {
        'error' => 'Unprocessable Entity',
        'message' => 'Validation failed',
        'errors' => {
          'email' => ['is not a valid email address'],
          'phone' => ['is invalid']
        }
      }
    end

    it 'returns errors' do
      request_page(expected_status: 422)
      expect(json_body).to eq expected_body
    end
  end

  context 'with parameters that cannot be updated' do
    let(:request_method) { :post }
    let(:request_path) { '/api/messages' }

    let(:request_params) do
      {
        'uid' => 'this should not be set',
        'name' => new_name,
        'email' => new_email,
        'message' => new_message
      }
    end

    it 'does not update the fields' do
      request_page(expected_status: 201)
      expect(json_body.fetch('uid')).to match(/\A[0-9a-z]{8}+\z/)
    end
  end
end
