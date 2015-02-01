FactoryGirl.define do
  factory :message do
    site
    subject { Faker::Name.name }
    name { Faker::Name.name }
    email { Faker::Internet.email }
    phone { "+447#{rand(1_000_000_000).to_s.ljust(9, '0')}" }
    message { Faker::Lorem.paragraph }
  end
end
