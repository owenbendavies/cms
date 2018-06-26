FactoryBot.define do
  factory :page do
    site
    name { Faker::Name.name }
    html_content { "<p>#{Faker::Lorem.paragraph}</p>" }
    custom_html { "<p>#{Faker::Lorem.paragraph}</p>" }
  end
end
