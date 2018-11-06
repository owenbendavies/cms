require 'rails_helper'

RSpec.describe Types::MessageType do
  subject(:result) { GraphqlSchema.execute(query, context: context) }

  let(:site) { FactoryBot.create(:site) }
  let(:user) { FactoryBot.build(:user, site: site) }
  let(:context) { { user: user, site: site } }

  let!(:message) { FactoryBot.create(:message, site: site) }

  let(:query) do
    <<~BODY
      query {
        messages(orderBy: {field: CREATED_AT, direction: DESC}) {
          nodes {
            id
            name
            email
            phone
            message
            privacyPolicyAgreed
            createdAt
            updatedAt
          }
          totalCount
        }
      }
    BODY
  end

  let(:expected_result) do
    [
      {
        'messages' => {
          'nodes' => [
            {
              'id' => Base64.urlsafe_encode64("Message-#{message.uid}"),
              'name' => message.name,
              'email' => message.email,
              'phone' => message.phone,
              'message' => message.message,
              'privacyPolicyAgreed' => true,
              'createdAt' => message.created_at.iso8601,
              'updatedAt' => message.updated_at.iso8601
            }
          ],
          'totalCount' => 1
        }
      }
    ]
  end

  it 'returns all feilds' do
    expect(result.values).to eq expected_result
  end
end
