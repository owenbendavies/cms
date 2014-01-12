FactoryGirl.define do
  factory :image do
    site_id { Digest::MD5.hexdigest(rand.to_s) }
    name { Faker::Name.name.gsub("'", '') }
    created_by { Digest::MD5.hexdigest(rand.to_s) }
    updated_by { Digest::MD5.hexdigest(rand.to_s) }
    filename { "#{Digest::MD5.hexdigest(rand.to_s)}.jpg" }
  end
end
