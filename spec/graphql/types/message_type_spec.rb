require 'rails_helper'

RSpec.describe Types::MessageType do
  subject(:result) { GraphqlSchema.execute(query, context: context) }

  let(:site) { FactoryBot.create(:site) }
  let(:user) { FactoryBot.build(:user, site: site) }
  let(:context) { { user: user, site: site } }

  context 'with all fields' do
    let!(:message) { FactoryBot.create(:message, site: site) }

    let(:query) do
      <<~BODY
        query {
          messages {
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
            ]
          }
        }
      ]
    end

    it 'returns all feilds' do
      expect(result.values).to eq expected_result
    end
  end

  context 'with total count' do
    let!(:message) { FactoryBot.create(:message, site: site) }

    let(:query) do
      <<~BODY
        query {
          messages(first: 1) {
            nodes {
              name
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
              { 'name' => message.name }
            ],
            'totalCount' => 2
          }
        }
      ]
    end

    before do
      FactoryBot.create(:message, site: site, created_at: 10.days.ago)
    end

    it 'returns total number' do
      expect(result.values).to eq expected_result
    end
  end
end
