# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  site_id    :integer          not null
#  subject    :string(64)       not null
#  name       :string(64)       not null
#  email      :string(64)       not null
#  phone      :string(32)
#  delivered  :boolean          default(FALSE), not null
#  message    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  fk__messages_site_id  (site_id)
#
# Foreign Keys
#
#  fk_messages_site_id  (site_id => sites.id)
#

require 'rails_helper'

RSpec.describe Message do
  it { should belong_to(:site) }

  it 'is versioned', versioning: true do
    is_expected.to be_versioned
  end

  it { is_expected.to strip_attribute(:subject).collapse_spaces }
  it { is_expected.to strip_attribute(:name).collapse_spaces }
  it { is_expected.to strip_attribute(:email).collapse_spaces }
  it { is_expected.to_not strip_attribute(:message) }

  describe 'validate' do
    it { should validate_presence_of(:site) }

    it { should validate_presence_of(:subject) }

    it { should validate_presence_of(:name) }

    it { should validate_length_of(:name).is_at_most(64) }

    it { should validate_presence_of(:email) }

    it { should allow_value('someone@example.com').for(:email) }

    it do
      should_not allow_value(
        'someone@'
      ).for(:email).with_message('is not a valid email address')
    end

    it { should validate_presence_of(:message) }

    it { should validate_length_of(:message).is_at_most(2048) }

    [
      'Do you want to promote your profile and get more twitter followers.',
      'Get thousands of facebook followers to your site',
      'How about 100k facebook visitors!',
      'Millions of Facebook page likes',
      'We can get you Facebook likes',
      'We can help your website to get on first page of Google',
      'We can increase rankings of your website in search engines.',
      'We strongly believe that we have excellent SEO services',
      'superbsocial'
    ].each do |message|
      it do
        should_not allow_value(
          message
        ).for(:message).with_message('Please do not send spam messages.')
      end
    end

    it do
      should validate_length_of(:do_not_fill_in)
        .is_at_most(0)
        .with_message('do not fill in')
    end
  end

  describe '#deliver' do
    subject { FactoryGirl.create(:message) }

    it 'sends an email' do
      expect(subject.delivered).to eq false

      subject.deliver

      expect(ActionMailer::Base.deliveries.size).to eq 1
      expect(subject.delivered).to eq true

      email = ActionMailer::Base.deliveries.last
      expect(email.subject).to eq subject.subject
    end
  end

  describe '#phone=' do
    it 'formats phone numbers' do
      subject.phone = '+44 1234 567 890'
      expect(subject.phone).to eq '+441234567890'
    end

    it 'defaults to uk' do
      subject.phone = '01234567890'
      expect(subject.phone).to eq '+441234567890'
    end
  end
end
