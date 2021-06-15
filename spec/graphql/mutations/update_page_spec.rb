require 'rails_helper'

RSpec.describe Mutations::UpdatePage do
  subject(:result) { GraphqlSchema.execute(query, context: context, variables: variables) }

  let(:site) { FactoryBot.create(:site) }
  let(:user) { FactoryBot.build(:user, site: site) }
  let(:page) { FactoryBot.create(:page, site: site) }
  let(:context) { { user: user, site: site } }

  let(:mutation_id) { SecureRandom.uuid }
  let(:page_id) { Base64.urlsafe_encode64("Page-#{page.id}") }

  let(:query) do
    <<~BODY
      mutation UpdatePage($input: UpdatePageInput!) {
        updatePage(input: $input) {
          clientMutationId
          errors {
            field
            messages
          }
          page {
            contactForm
            customHtml
            htmlContent
            id
            name
            private
            url
          }
        }
      }
    BODY
  end

  context 'with valid data' do
    let(:updated_properties) do
      {
        'contactForm' => true,
        'customHtml' => '<h1>Custom HTML</h1>',
        'htmlContent' => '<p>My page.</p>',
        'name' => 'My Page',
        'private' => true
      }
    end

    let(:variables) do
      {
        'input' => { 'clientMutationId' => mutation_id, 'pageId' => page_id }.merge(updated_properties)
      }
    end

    let(:expected_result) do
      [
        {
          'updatePage' => {
            'clientMutationId' => mutation_id,
            'errors' => [],
            'page' => { 'id' => page_id, 'url' => 'my_page' }.merge(updated_properties)
          }
        }
      ]
    end

    it 'updates the page' do
      expect(result.values).to eq expected_result
    end
  end

  context 'with missing keys' do
    let(:variables) do
      {
        'input' => {
          'clientMutationId' => mutation_id,
          'pageId' => page_id,
          'name' => 'New Name'
        }
      }
    end

    let(:expected_result) do
      [
        {
          'updatePage' => {
            'clientMutationId' => mutation_id,
            'errors' => [],
            'page' => {
              'contactForm' => page.contact_form,
              'customHtml' => page.custom_html,
              'htmlContent' => page.html_content,
              'id' => page_id,
              'name' => 'New Name',
              'private' => page.private,
              'url' => 'new_name'
            }
          }
        }
      ]
    end

    it 'does not delete other values' do
      expect(result.values).to eq expected_result
    end
  end

  context 'with invalid data' do
    let(:variables) do
      {
        'input' => {
          'clientMutationId' => mutation_id,
          'pageId' => page_id,
          'name' => 'Admin'
        }
      }
    end

    let(:expected_result) do
      [
        {
          'updatePage' => {
            'clientMutationId' => mutation_id,
            'errors' => [
              {
                'field' => 'url',
                'messages' => ['is reserved']
              }
            ],
            'page' => nil
          }
        }
      ]
    end

    it 'returns the error' do
      expect(result.values).to eq expected_result
    end
  end
end
