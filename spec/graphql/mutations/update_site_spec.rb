require 'rails_helper'

RSpec.describe Mutations::UpdateSite do
  subject(:result) { GraphqlSchema.execute(query, context: context, variables: variables) }

  let(:site) { FactoryBot.create(:site) }
  let(:user) { FactoryBot.build(:user, site: site) }
  let(:context) { { user: user, site: site } }

  let(:mutation_id) { SecureRandom.uuid }
  let(:site_id) { Base64.urlsafe_encode64("Site-#{site.id}") }

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
            charityNumber
            css
            googleAnalytics
            id
            mainMenuInFooter
            name
            separateHeader
            sidebarHtmlContent
          }
        }
      }
    BODY
  end

  context 'with valid data' do
    let(:updated_properties) do
      {
        'charityNumber' => new_number.to_s,
        'css' => 'body{background-color: red}',
        'googleAnalytics' => new_google_analytics,
        'mainMenuInFooter' => true,
        'name' => new_company_name,
        'separateHeader' => false,
        'sidebarHtmlContent' => new_html
      }
    end

    let(:variables) do
      {
        'input' => { 'clientMutationId' => mutation_id, 'siteId' => site_id }.merge(updated_properties)
      }
    end

    let(:expected_result) do
      [
        {
          'updateSite' => {
            'clientMutationId' => mutation_id,
            'errors' => [],
            'site' => { 'id' => site_id }.merge(updated_properties)
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
              'charityNumber' => site.charity_number,
              'css' => site.css,
              'googleAnalytics' => site.google_analytics,
              'id' => site_id,
              'mainMenuInFooter' => site.main_menu_in_footer,
              'name' => new_company_name,
              'separateHeader' => site.separate_header,
              'sidebarHtmlContent' => site.sidebar_html_content
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
              'charityNumber' => site.charity_number,
              'css' => site.css,
              'googleAnalytics' => nil,
              'id' => site_id,
              'mainMenuInFooter' => site.main_menu_in_footer,
              'name' => site.name,
              'separateHeader' => site.separate_header,
              'sidebarHtmlContent' => site.sidebar_html_content
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
