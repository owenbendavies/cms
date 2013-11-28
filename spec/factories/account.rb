FactoryGirl.define do
  factory :account do
    email { Faker::Internet.safe_email }
    sites ['localhost']
    updated_from { Faker::Internet.ip_v4_address }
    password { Faker::Lorem.words(4).join }
    password_confirmation { password }
  end
end
