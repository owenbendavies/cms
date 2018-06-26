FactoryBot.define do
  factory :image do
    site
    name { Faker::Name.name.delete("'") }
    filename { "#{SecureRandom.uuid}.jpg" }
  end
end
