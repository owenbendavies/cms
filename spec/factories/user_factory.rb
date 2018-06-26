FactoryBot.define do
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
