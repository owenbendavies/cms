FactoryBot.define do
  factory :site do
    host { Faker::Internet.domain_name }
    name { Faker::Company.name.delete("'") }
    google_analytics { "UA-#{Faker::Number.number(3)}-#{Faker::Number.digit}" }
    charity_number { rand 10_000 }
    css { '.page { border: 1px solid black }' }

    trait :with_links do
      links do
        [
          {
            'name' => Faker::Name.name,
            'url' => Faker::Internet.url,
            'icon' => 'fas fa-facebook fa-fw'
          }
        ]
      end
    end

    trait :with_privacy_policy do
      association :privacy_policy_page, factory: :page
    end
  end
end
