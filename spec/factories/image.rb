FactoryGirl.define do
  factory :image do
    site
    name { Faker::Name.name.gsub("'", '') }
    filename { "#{Digest::MD5.hexdigest(rand.to_s)}.jpg" }
    association :created_by, factory: :account
    association :updated_by, factory: :account
  end
end
