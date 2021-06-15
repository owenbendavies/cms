require 'rails_helper'

RSpec.describe Mutations::DeleteMessages do
  subject(:result) { GraphqlSchema.execute(query, context: context, variables: variables) }

  let(:site) { FactoryBot.create(:site) }
  let(:user) { FactoryBot.build(:user, site: site) }
  let(:context) { { user: user, site: site } }

  let(:mutation_id) { SecureRandom.uuid }
  let!(:message1) { FactoryBot.create(:message, site: site) }
  let!(:message2) { FactoryBot.create(:message, site: site) }
  let(:message1_id) { Base64.urlsafe_encode64("Message-#{message1.id}") }
  let(:message2_id) { Base64.urlsafe_encode64("Message-#{message2.id}") }

  let(:query) do
    <<~BODY
      mutation DeleteMessage($input: DeleteMessagesInput!) {
        deleteMessages(input: $input) {
          clientMutationId
          messages {
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
        'messageIds' => [message1_id, message2_id]
      }
    }
  end

  let(:expected_result) do
    [
      {
        'deleteMessages' => {
          'clientMutationId' => mutation_id,
          'messages' => [
            { 'id' => message1_id },
            { 'id' => message2_id }
          ]
        }
      }
    ]
  end

  before do
    FactoryBot.create(:message, site: site)
  end

  it 'deletes the message' do
    expect { result }
      .to change(Message, :count).by(-2)
  end

  it 'returns the message' do
    expect(result.values).to eq expected_result
  end
end
