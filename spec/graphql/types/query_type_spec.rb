require 'rails_helper'

RSpec.describe Types::QueryType do
  subject(:result) { GraphqlSchema.execute(query, context: context) }

  let(:site) { FactoryBot.create(:site) }
  let(:user) { FactoryBot.build(:user, site: site) }
  let(:context) { { user: user, site: site } }

  context 'with messages query' do
    context 'with all fields' do
      let!(:message) { FactoryBot.create(:message, site: site) }

      let(:query) do
        <<~BODY
          query {
            messages {
              uid
              name
              email
              phone
              message
              privacyPolicyAgreed
              createdAt
              updatedAt
            }
          }
        BODY
      end

      let(:expected_result) do
        [
          {
            'messages' => [
              {
                'uid' => message.uid,
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
        ]
      end

      it 'returns all feilds' do
        expect(result.values).to eq expected_result
      end
    end

    context 'with multiple messages' do
      let!(:message1) do
        FactoryBot.create(
          :message,
          name: 'Message 1',
          site: site,
          created_at: Time.zone.now - 2.days,
          updated_at: Time.zone.now - 2.days
        )
      end

      let!(:message2) do
        FactoryBot.create(
          :message,
          site: site,
          name: 'Message 2',
          created_at: Time.zone.now - 1.day,
          updated_at: Time.zone.now - 1.day
        )
      end

      let(:query) do
        <<~BODY
          query {
            messages {
              name
            }
          }
        BODY
      end

      let(:expected_result) do
        [
          {
            'messages' => [
              { 'name' => message2.name },
              { 'name' => message1.name }
            ]
          }
        ]
      end

      it 'returns ordered messages' do
        expect(result.values).to eq expected_result
      end
    end

    context 'with other sites messages' do
      let!(:message) { FactoryBot.create(:message, name: 'site message', site: site) }

      let(:query) do
        <<~BODY
          query {
            messages {
              name
            }
          }
        BODY
      end

      let(:expected_result) do
        [
          {
            'messages' => [
              { 'name' => message.name }
            ]
          }
        ]
      end

      before do
        FactoryBot.create(:message, name: 'other site message')
      end

      it 'returns scoped messages' do
        expect(result.values).to eq expected_result
      end
    end
  end
end
