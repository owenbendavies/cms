require 'rails_helper'

RSpec.describe GraphqlSchema do
  let(:site) { create(:site) }
  let(:user) { build(:user, site:) }
  let(:context) { { user:, site: } }
  let(:id) { Base64.urlsafe_encode64("Message-#{message.id}") }

  describe '.id_from_object' do
    subject(:result) { described_class.id_from_object(message, nil, context) }

    let(:message) { build(:message) }

    it 'returns an id generated from the object' do
      expect(result).to eq id
    end
  end

  describe '.object_from_id' do
    subject(:result) { described_class.object_from_id(id, context) }

    context 'with in scope object' do
      let(:message) { create(:message, site:) }

      it 'returns the object' do
        expect(result).to eq message
      end
    end

    context 'with out of scope object' do
      let(:message) { create(:message) }

      it 'raises error' do
        expect { result }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '.resolve_type' do
    subject do
      described_class.resolve_type(GraphQL::Types::Relay::Node, object, context).name
    end

    %i[image message page site].each do |type|
      context "with #{type}" do
        let(:object) { create(type) }

        it { is_expected.to eq "Types::#{type.to_s.classify}Type" }
      end
    end
  end
end
