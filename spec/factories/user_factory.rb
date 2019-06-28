FactoryBot.define do
  factory :user do
    id { SecureRandom.uuid }
    name { Faker::Name.name }
    email { Faker::Internet.email }

    groups do
      group_names = [site]
      group_names.compact!
      group_names.map!(&:host)
    end

    transient do
      site { nil }
    end

    trait :admin do
      groups { ['admin'] }
    end
  end
end
