require 'rails_helper'

RSpec.describe Mutations::CreatePage do
  subject(:result) { GraphqlSchema.execute(query, context: context, variables: variables) }

  let(:site) { FactoryBot.create(:site) }
  let(:user) { FactoryBot.build(:user, site: site) }
  let(:page) { Page.ordered.last }
  let(:context) { { user: user, site: site } }

  let(:mutation_id) { SecureRandom.uuid }
  let(:page_id) { Base64.urlsafe_encode64("Page-#{page.id}") }

  let(:query) do
    <<~BODY
      mutation CreatePage($input: CreatePageInput!) {
        createPage(input: $input) {
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
    let(:create_properties) do
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
        'input' => {
          'clientMutationId' => mutation_id
        }.merge(create_properties)
      }
    end

    let(:expected_result) do
      [
        {
          'createPage' => {
            'clientMutationId' => mutation_id,
            'errors' => [],
            'page' => {
              'id' => page_id,
              'url' => 'my_page'
            }.merge(create_properties)
          }
        }
      ]
    end

    it 'creates the page' do
      expect(result.values).to eq expected_result
    end
  end

  context 'with invalid data' do
    let(:variables) do
      {
        'input' => {
          'clientMutationId' => mutation_id,
          'name' => 'Admin'
        }
      }
    end

    let(:expected_result) do
      [
        {
          'createPage' => {
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
