FactoryGirl.define do
  factory :page do
    site
    name { Faker::Name.name }
    html_content { "<p>#{ Faker::Lorem.paragraph }</p>" }
    association :created_by, factory: :user
    association :updated_by, factory: :user
  end
end
