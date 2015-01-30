# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(64)       not null
#  encrypted_password     :string(64)       not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  failed_attempts        :integer          default("0"), not null
#  unlock_token           :string
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#

require 'rails_helper'

RSpec.describe User do
  it 'has a gravatar_url' do
    user = described_class.new(email: 'test@example.com')
    md5 = '55502f40dc8b7c769880b10874abc9d0'

    expect(user.gravatar_url)
      .to eq "https://secure.gravatar.com/avatar/#{md5}.png?d=mm&r=PG&s=40"
  end

  describe '#sites' do
    subject { FactoryGirl.create(:user) }
    let!(:site1) { FactoryGirl.create(:site, name: 'a') }
    let!(:site2) { FactoryGirl.create(:site, name: 'b') }

    it 'returns sites sorted by site name' do
      subject.sites << site1
      subject.sites << site2

      expect(subject.sites).to eq [site1, site2]
    end
  end

  it 'is versioned', versioning: true do
    is_expected.to be_versioned
  end

  it 'strips attributes' do
    user = FactoryGirl.create(:user, email: "  #{new_email} ")
    expect(user.email).to eq new_email
  end

  describe 'validate' do
    it { should validate_presence_of(:email) }

    it { should ensure_length_of(:email).is_at_most(64) }

    it { should allow_value('someone@example.com').for(:email) }

    it do
      should_not allow_value(
        'someone@'
      ).for(:email).with_message('is not a valid email address')
    end

    it { should validate_confirmation_of(:password) }

    it { should ensure_length_of(:password).is_at_least(8).is_at_most(64) }

    it { should allow_value('apel203pd0pa').for(:password) }

    it { should_not allow_value('password').for(:password) }
  end
end
