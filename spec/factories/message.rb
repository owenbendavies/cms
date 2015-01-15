FactoryGirl.define do
  factory :message do
    site
    subject { Faker::Name.name }
    name { Faker::Name.name }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }
    message { Faker::Lorem.paragraph }
  end
end
