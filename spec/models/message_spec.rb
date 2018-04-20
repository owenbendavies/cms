# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  site_id    :integer          not null
#  name       :string(64)       not null
#  email      :string(64)       not null
#  phone      :string(32)
#  message    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  uid        :string           not null
#
# Indexes
#
#  index_messages_on_created_at  (created_at)
#  index_messages_on_site_id     (site_id)
#  index_messages_on_uid         (uid) UNIQUE
#
# Foreign Keys
#
#  fk_messages_site_id  (site_id => sites.id)
#

require 'rails_helper'

RSpec.describe Message do
  it_behaves_like 'model with uid' do
    subject(:model) { FactoryBot.build(:message) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:site) }
  end

  describe 'scopes' do
    describe '.ordered' do
      it 'returns ordered by created descending' do
        message1 = FactoryBot.create(:message, created_at: Time.zone.now - 1.minute)
        message3 = FactoryBot.create(:message, created_at: Time.zone.now - 3.minutes)
        message2 = FactoryBot.create(:message, created_at: Time.zone.now - 2.minutes)

        expect(described_class.ordered).to eq [message1, message2, message3]
      end
    end
  end

  describe 'before validations' do
    it { is_expected.to strip_attribute(:name).collapse_spaces }
    it { is_expected.to strip_attribute(:email).collapse_spaces }
    it { is_expected.not_to strip_attribute(:message) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:site) }

    it { is_expected.to validate_length_of(:name).is_at_least(3).is_at_most(64) }
    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to allow_value('someone@example.com').for(:email) }

    it do
      is_expected.not_to allow_value('test@')
        .for(:email).with_message('is not a valid email address')
    end

    it { is_expected.to validate_length_of(:email).is_at_most(64) }
    it { is_expected.to validate_presence_of(:email) }

    it { is_expected.to validate_length_of(:phone).is_at_most(32) }
    it { is_expected.to allow_value('07910201293').for(:phone) }
    it { is_expected.to allow_value('+1-541-754-3010').for(:phone) }
    it { is_expected.to allow_value(nil).for(:phone) }
    it { is_expected.not_to allow_value('9210').for(:phone).with_message('is invalid') }

    it { is_expected.to validate_length_of(:message).is_at_most(2048) }
    it { is_expected.to validate_presence_of(:message) }

    it do
      is_expected.to validate_length_of(:do_not_fill_in)
        .is_at_most(0).with_message('do not fill in')
    end
  end
end
