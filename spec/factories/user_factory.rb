FactoryBot.define do
  factory :user do
    id { SecureRandom.uuid }
    name { Faker::Name.name }
    email { Faker::Internet.email }

    groups do
      groups = [site].compact.map(&:host)
      groups << 'admin' if site_admin
      groups
    end

    transient do
      site { nil }
      site_admin { false }
    end
  end
end
