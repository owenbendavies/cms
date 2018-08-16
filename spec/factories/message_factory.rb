FactoryBot.define do
  factory :message do
    site

    name { Faker::Name.name }
    email { Faker::Internet.email }
    phone { "+4478#{rand(100_000_000).to_s.ljust(8, '1')}" }
    message { Faker::Lorem.paragraph }
    privacy_policy_agreed { true }
  end
end
