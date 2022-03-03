FactoryBot.define do
  factory :site do
    host { Faker::Internet.domain_name }
    name { Faker::Company.name.delete("'") }
    email { Faker::Internet.email }
    google_analytics { "UA-#{Faker::Number.number(digits: 3)}-#{Faker::Number.digit}" }
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
      after(:create) do |site, _evaluator|
        page = create(:page, site:)

        site.update!(privacy_policy_page: page)
      end
    end
  end
end
