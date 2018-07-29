require 'rails_helper'

RSpec.describe Message do
  it_behaves_like 'model with uid'
  it_behaves_like 'model with versioning'

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
    it { is_expected.to allow_value('HTML & escape - characters').for(:message) }
    it { is_expected.to allow_value("Don't remove").for(:message) }

    it do
      is_expected.not_to allow_value('Hello <a>bad</a>')
        .for(:message)
        .with_message('html is not allowed')
    end

    it do
      is_expected.to validate_length_of(:do_not_fill_in)
        .is_at_most(0).with_message('do not fill in')
    end

    it { is_expected.not_to validate_presence_of(:privacy_policy_agreed) }

    context 'when site has privacy policy' do
      subject { FactoryBot.build(:message, site: site) }

      let(:site) { FactoryBot.build(:site, :with_privacy_policy) }

      it { is_expected.to validate_presence_of(:privacy_policy_agreed) }
    end
  end
end
