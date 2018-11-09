require 'rails_helper'

RSpec.describe GraphqlSchema do
  let(:site) { FactoryBot.create(:site) }
  let(:user) { FactoryBot.build(:user, site: site) }
  let(:context) { { user: user, site: site } }
  let(:id) { Base64.urlsafe_encode64("Message-#{message.uid}") }

  describe '.id_from_object' do
    subject(:result) { described_class.id_from_object(message, nil, context) }

    let(:message) { FactoryBot.build(:message) }

    it 'returns an id generated from the object' do
      expect(result).to eq id
    end
  end

  describe '.object_from_id' do
    subject(:result) { described_class.object_from_id(id, context) }

    context 'with in scope object' do
      let(:message) { FactoryBot.create(:message, site: site) }

      it 'returns the object' do
        expect(result).to eq message
      end
    end

    context 'with out of scope object' do
      let(:message) { FactoryBot.create(:message) }

      it 'returns nil' do
        expect(result).to eq nil
      end
    end
  end

  describe '.resolve_type' do
    subject(:result) do
      described_class.resolve_type(GraphQL::Relay::Node.interface, object, context)
    end

    %i[message page site].each do |type|
      context "with #{type}" do
        let(:object) { FactoryBot.create(type) }

        it 'returns MessageType' do
          expect(result.name).to eq type.to_s.classify
        end
      end
    end
  end
end
