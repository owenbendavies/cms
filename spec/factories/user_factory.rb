FactoryBot.define do
  factory :user do
    id { SecureRandom.uuid }
    name { Faker::Name.name }
    email { Faker::Internet.email }
    groups { [site].compact.map(&:host) }

    transient do
      site { nil }
    end

    trait :admin do
      groups { ['admin'] }
    end
  end
end
