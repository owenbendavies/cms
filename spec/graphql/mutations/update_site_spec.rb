require 'rails_helper'

RSpec.describe Mutations::UpdateSite do
  subject(:result) { GraphqlSchema.execute(query, context: context, variables: variables) }

  let(:site) { FactoryBot.create(:site) }
  let(:user) { FactoryBot.build(:user, site: site) }
  let(:context) { { user: user, site: site } }

  let(:mutation_id) { SecureRandom.uuid }
  let(:site_id) { Base64.urlsafe_encode64("Site-#{site.uid}") }

  let(:query) do
    <<~BODY
      mutation UpdateSite($input: UpdateSiteInput!) {
        updateSite(input: $input) {
          clientMutationId
          errors {
            field
            messages
          }
          site {
            id
            name
            googleAnalytics
            charityNumber
            sidebarHtmlContent
            mainMenuInFooter
            separateHeader
          }
        }
      }
    BODY
  end

  context 'with valid data' do
    let(:updated_properties) do
      {
        'name' => new_company_name,
        'googleAnalytics' => new_google_analytics,
        'charityNumber' => new_number.to_s,
        'sidebarHtmlContent' => new_html,
        'mainMenuInFooter' => true,
        'separateHeader' => false
      }
    end

    let(:variables) do
      {
        'input' => {
          'clientMutationId' => mutation_id,
          'siteId' => site_id
        }.merge(updated_properties)
      }
    end

    let(:expected_result) do
      [
        {
          'updateSite' => {
            'clientMutationId' => mutation_id,
            'errors' => [],
            'site' => {
              'id' => site_id
            }.merge(updated_properties)
          }
        }
      ]
    end

    it 'updates the site' do
      expect(result.values).to eq expected_result
    end
  end

  context 'with missing keys' do
    let(:variables) do
      {
        'input' => {
          'clientMutationId' => mutation_id,
          'siteId' => site_id,
          'name' => new_company_name
        }
      }
    end

    let(:expected_result) do
      [
        {
          'updateSite' => {
            'clientMutationId' => mutation_id,
            'errors' => [],
            'site' => {
              'id' => site_id,
              'name' => new_company_name,
              'googleAnalytics' => site.google_analytics,
              'charityNumber' => site.charity_number,
              'sidebarHtmlContent' => site.sidebar_html_content,
              'mainMenuInFooter' => site.main_menu_in_footer,
              'separateHeader' => site.separate_header
            }
          }
        }
      ]
    end

    it 'does not delete other values' do
      expect(result.values).to eq expected_result
    end
  end

  context 'with nil values' do
    let(:variables) do
      {
        'input' => {
          'clientMutationId' => mutation_id,
          'siteId' => site_id,
          'googleAnalytics' => nil
        }
      }
    end

    let(:expected_result) do
      [
        {
          'updateSite' => {
            'clientMutationId' => mutation_id,
            'errors' => [],
            'site' => {
              'id' => site_id,
              'name' => site.name,
              'googleAnalytics' => nil,
              'charityNumber' => site.charity_number,
              'sidebarHtmlContent' => site.sidebar_html_content,
              'mainMenuInFooter' => site.main_menu_in_footer,
              'separateHeader' => site.separate_header
            }
          }
        }
      ]
    end

    it 'sets the value to nil' do
      expect(result.values).to eq expected_result
    end
  end

  context 'with invalid data' do
    let(:variables) do
      {
        'input' => {
          'clientMutationId' => mutation_id,
          'siteId' => site_id,
          'googleAnalytics' => 'x' * 33
        }
      }
    end

    let(:expected_result) do
      [
        {
          'updateSite' => {
            'clientMutationId' => mutation_id,
            'errors' => [
              {
                'field' => 'googleAnalytics',
                'messages' => ['is invalid', 'is too long (maximum is 32 characters)']
              }
            ],
            'site' => nil
          }
        }
      ]
    end

    it 'returns the error' do
      expect(result.values).to eq expected_result
    end
  end
end
