FactoryGirl.define do
  factory :image do
    site
    name { Faker::Name.name.gsub("'", '') }
    filename { "#{Digest::MD5.hexdigest(rand.to_s)}.jpg" }
    association :created_by, factory: :user
    association :updated_by, factory: :user
  end
end
