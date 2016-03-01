# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(64)       not null
#  encrypted_password     :string(64)
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
#  sysadmin               :boolean          default(FALSE), not null
#  name                   :string(64)       not null
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invited_by_id          :integer
#
# Indexes
#
#  fk__users_invited_by_id              (invited_by_id)
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
# Foreign Keys
#
#  fk_users_invited_by_id  (invited_by_id => users.id)
#

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a gravatar_url' do
    user = described_class.new(email: 'test@example.com')
    md5 = '55502f40dc8b7c769880b10874abc9d0'

    expect(user.gravatar_url).to eq "https://secure.gravatar.com/avatar/#{md5}.png?d=mm&r=PG&s=40"
  end

  it { should have_many(:site_settings).dependent(:destroy) }
  it { should have_many(:sites).order(:host) }

  it { is_expected.to strip_attribute(:name).collapse_spaces }
  it { is_expected.to strip_attribute(:email).collapse_spaces }

  describe 'validate', secure_password: true do
    it { should validate_presence_of(:email) }
    it { should validate_length_of(:email).is_at_most(64) }
    it { should allow_value('someone@example.com').for(:email) }

    it do
      should_not allow_value('someone@').for(:email).with_message('is not a valid email address')
    end

    it { should validate_confirmation_of(:password) }
    it { should validate_length_of(:password).is_at_least(8).is_at_most(64) }
    it { should allow_value('apel203pd0pa').for(:password) }
    it { should_not allow_value('password').for(:password) }

    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(3).is_at_most(64) }
  end

  describe '#admin_for_site?' do
    it 'returns true when admin of site' do
      user = FactoryGirl.create(:user)
      site = FactoryGirl.create(:site)
      user.site_settings.create(site: site, admin: true)

      expect(user.admin_for_site?(site)).to eq true
    end

    it 'returns false when admin of another site' do
      user = FactoryGirl.create(:user)
      site = FactoryGirl.create(:site)
      another_site = FactoryGirl.create(:site)
      user.site_settings.create(site: site)
      user.site_settings.create(site: another_site, admin: true)

      expect(user.admin_for_site?(site)).to eq false
    end

    it 'returns false when admin of no sites' do
      user = FactoryGirl.create(:user)
      site = FactoryGirl.create(:site)
      user.site_settings.create(site: site)

      expect(user.admin_for_site?(site)).to eq false
    end

    it 'returns false when no sites' do
      user = FactoryGirl.create(:user)
      site = FactoryGirl.create(:site)

      expect(user.admin_for_site?(site)).to eq false
    end
  end

  describe '#site_ids' do
    it 'returns all site ids for a user' do
      user = FactoryGirl.create(:user)

      site = FactoryGirl.create(:site)

      user.site_settings.create(site: site)

      expect(user.site_ids).to eq [site.id]
    end
  end
end
