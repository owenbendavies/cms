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
#  message    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_agent :text
#  ip_address :string(45)
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

RSpec.describe Message, type: :model do
  it { is_expected.to strip_attribute(:subject).collapse_spaces }
  it { is_expected.to strip_attribute(:name).collapse_spaces }
  it { is_expected.to strip_attribute(:email).collapse_spaces }
  it { is_expected.not_to strip_attribute(:message) }

  describe '#valid?' do
    it 'validates database schema' do
      should validate_presence_of(:name)
    end

    it { should validate_length_of(:name).is_at_least(3).is_at_most(64) }

    it { should allow_value('someone@example.com').for(:email) }
    it { should_not allow_value('test@').for(:email).with_message('is not a valid email address') }

    it { should validate_length_of(:message).is_at_most(2048) }

    it { should validate_length_of(:do_not_fill_in).is_at_most(0).with_message('do not fill in') }
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
