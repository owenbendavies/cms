require 'rails_helper'

RSpec.describe 'GraphQL' do
  let(:request_method) { :post }
  let(:request_path) { '/graphql' }

  context 'with an unauthorized user' do
    let(:expected_status) { 404 }

    it 'renders page not found' do
      request_page
    end
  end

  context 'with an authorized user' do
    let(:request_user) { FactoryBot.build(:user, site: site) }

    context 'with an errror' do
      let(:expected_body) do
        {
          'errors' => [
            { 'message' => 'No query string was present' }
          ]
        }
      end

      it 'returns the error' do
        request_page

        expect(json_body).to eq expected_body
      end
    end

    context 'with a query' do
      let!(:message) { FactoryBot.create(:message, site: site) }

      let(:query) do
        <<~BODY
          query {
            messages {
              name
            }
          }
        BODY
      end

      let(:request_params) do
        {
          'query' => query
        }
      end

      let(:expected_body) do
        {
          'data' => {
            'messages' => [
              {
                'name' => message.name
              }
            ]
          }
        }
      end

      it 'returns results' do
        request_page

        expect(json_body).to eq expected_body
      end
    end
  end
end
