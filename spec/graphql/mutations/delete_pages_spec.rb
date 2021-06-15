require 'rails_helper'

RSpec.describe Mutations::DeletePages do
  subject(:result) { GraphqlSchema.execute(query, context: context, variables: variables) }

  let(:site) { FactoryBot.create(:site) }
  let(:user) { FactoryBot.build(:user, site: site) }
  let(:context) { { user: user, site: site } }

  let(:mutation_id) { SecureRandom.uuid }
  let!(:page1) { FactoryBot.create(:page, site: site) }
  let!(:page2) { FactoryBot.create(:page, site: site) }
  let(:page1_id) { Base64.urlsafe_encode64("Page-#{page1.id}") }
  let(:page2_id) { Base64.urlsafe_encode64("Page-#{page2.id}") }

  let(:query) do
    <<~BODY
      mutation DeletePages($input: DeletePagesInput!) {
        deletePages(input: $input) {
          clientMutationId
          pages {
            id
          }
        }
      }
    BODY
  end

  let(:variables) do
    {
      'input' => {
        'clientMutationId' => mutation_id,
        'pageIds' => [page1_id, page2_id]
      }
    }
  end

  let(:expected_result) do
    [
      {
        'deletePages' => {
          'clientMutationId' => mutation_id,
          'pages' => [
            { 'id' => page1_id },
            { 'id' => page2_id }
          ]
        }
      }
    ]
  end

  before do
    FactoryBot.create(:page, site: site)
  end

  it 'deletes the pages' do
    expect { result }
      .to change(Page, :count).by(-2)
  end

  it 'returns the pages' do
    expect(result.values).to eq expected_result
  end
end
