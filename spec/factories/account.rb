FactoryGirl.define do
  factory :account do
    email { Faker::Internet.safe_email }
    password { 'Aq2%' + Faker::Lorem.words(3).join }
    password_confirmation { password }
  end
end
