# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(64)       not null
#  encrypted_password     :string(64)       not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  admin                  :boolean          default(FALSE), not null
#  name                   :string(64)       not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#

require 'rails_helper'

RSpec.describe User do
  it 'has a gravatar_url' do
    user = described_class.new(email: 'test@example.com')
    md5 = '55502f40dc8b7c769880b10874abc9d0'

    expect(user.gravatar_url)
      .to eq "https://secure.gravatar.com/avatar/#{md5}.png?d=mm&r=PG&s=40"
  end

  it { should have_many(:site_settings) }
  it { should have_many(:sites) }

  it 'is versioned', versioning: true do
    is_expected.to be_versioned
  end

  describe '.admin' do
    it 'returns all admins' do
      admin = FactoryGirl.create(:admin)
      FactoryGirl.create(:user)

      expect(described_class.admin).to eq [admin]
    end
  end

  it { is_expected.to strip_attribute(:name).collapse_spaces }
  it { is_expected.to strip_attribute(:email).collapse_spaces }

  describe 'validate', secure_password: true  do
    it { should validate_presence_of(:email) }
    it { should validate_length_of(:email).is_at_most(64) }
    it { should allow_value('someone@example.com').for(:email) }

    it do
      should_not allow_value(
        'someone@'
      ).for(:email).with_message('is not a valid email address')
    end

    it { should validate_confirmation_of(:password) }
    it { should validate_length_of(:password).is_at_least(8).is_at_most(64) }
    it { should allow_value('apel203pd0pa').for(:password) }
    it { should_not allow_value('password').for(:password) }

    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(3).is_at_most(64) }
  end

  describe '#all_sites' do
    it 'returns all sites for admin' do
      admin = FactoryGirl.create(:admin)

      site = FactoryGirl.create(
        :site,
        created_by: admin,
        updated_by: admin
      )

      expect(admin.all_sites).to eq [site]
    end

    it 'returns users sites' do
      user = FactoryGirl.create(:user)

      site = FactoryGirl.create(:site)

      FactoryGirl.create(:site)

      site.users << user

      expect(user.all_sites).to eq [site]
    end
  end
end
