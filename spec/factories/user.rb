FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(20, 30) }
    password_confirmation { password }
    confirmed_at { Time.zone.now }
  end
end
