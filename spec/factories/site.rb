FactoryGirl.define do
  factory :site do
    host { Faker::Internet.domain_name }
    name { Faker::Company.name.gsub("'", '') }

    association :created_by, factory: :user
    association :updated_by, factory: :user

    after(:create) do |site|
      site.users += [site.created_by, site.updated_by]
    end
  end
end
