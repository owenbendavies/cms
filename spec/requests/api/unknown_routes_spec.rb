require 'rails_helper'

RSpec.describe 'API Unknown routes' do
  shared_examples 'renders page not found' do
    let(:expected_status) { 404 }

    let(:expected_body) do
      {
        'error' => 'Not found',
        'message' => 'Please check API documentation',
        'errors' => {}
      }
    end

    it 'renders page not found' do
      request_page

      expect(json_body).to eq(expected_body)
    end
  end

  let(:request_method) { :get }

  context 'with root url' do
    let(:request_path) { '/api' }

    include_examples 'renders page not found'
  end

  context 'with unknown url' do
    let(:request_path) { '/api/badroute.json' }

    include_examples 'renders page not found'
  end

  context 'with unkown extension' do
    let(:request_path) { '/api/messages/id.txt' }

    include_examples 'renders page not found'
  end
end
