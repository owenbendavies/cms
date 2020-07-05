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
      let(:site_id) { Base64.urlsafe_encode64("Site-#{site.id}") }

      let(:query) do
        <<~BODY
          mutation UpdateSite($input: UpdateSiteInput!) {
            updateSite(input: $input) {
              errors {
                field
                messages
              }
              site {
                id
                name
              }
            }
          }
        BODY
      end

      let(:variables) do
        {
          'input' => {
            'siteId' => site_id,
            'name' => new_company_name
          }
        }
      end

      let(:request_params) do
        {
          'query' => query,
          'variables' => variables
        }
      end

      let(:expected_body) do
        {
          'data' => {
            'updateSite' => {
              'errors' => [],
              'site' => {
                'id' => site_id,
                'name' => new_company_name
              }
            }
          }
        }
      end

      it 'returns results' do
        request_page

        expect(json_body).to eq expected_body
      end

      it 'records who made the edit' do
        request_page

        expect(site.versions.last.whodunnit).to eq request_user.id.to_s
      end
    end
  end
end
