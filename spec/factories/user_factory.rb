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
#  google_uid             :string
#  uuid                   :string           not null
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
#  fk_users_invited_by_id  (invited_by_id => users.id) ON DELETE => no_action ON UPDATE => no_action
#

FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password(20, 30) }
    password_confirmation { password }
    confirmed_at { Time.zone.now }

    transient do
      site nil
      site_admin false
    end

    after(:create) do |user, evaluator|
      if evaluator.site
        user.site_settings.create!(
          site: evaluator.site,
          admin: evaluator.site_admin
        )
      end
    end

    trait :sysadmin do
      sysadmin true
    end

    trait :unconfirmed do
      confirmed_at nil

      after :build, &:skip_confirmation_notification!
    end

    trait :locked do
      locked_at { Time.zone.now }
    end

    trait :unconfirmed_email do
      unconfirmed_email { Faker::Internet.email }
    end
  end
end
