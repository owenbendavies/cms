require 'rails_helper'

RSpec.describe Types::MessageType do
  subject(:result) { GraphqlSchema.execute(query, context:) }

  let(:site) { create(:site) }
  let(:user) { build(:user, site:) }
  let(:context) { { user:, site: } }

  let!(:message) { create(:message, site:) }

  let(:query) do
    <<~BODY
      query {
        messages(orderBy: {field: CREATED_AT, direction: DESC}) {
          nodes {
            createdAt
            email
            id
            message
            name
            phone
            privacyPolicyAgreed
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
              'createdAt' => message.created_at.iso8601,
              'email' => message.email,
              'id' => Base64.urlsafe_encode64("Message-#{message.id}"),
              'message' => message.message,
              'name' => message.name,
              'phone' => message.phone,
              'privacyPolicyAgreed' => true,
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
