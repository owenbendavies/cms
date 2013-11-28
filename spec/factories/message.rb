FactoryGirl.define do
  factory :message do
    site_id { Digest::MD5.hexdigest(rand.to_s) }
    subject { Faker::Name.name }
    name { Faker::Name.name }
    email_address { Faker::Internet.safe_email }
    phone_number { Faker::PhoneNumber.phone_number }
    message { Faker::Lorem.paragraph }
    updated_from { Faker::Internet.ip_v4_address }
  end
end
