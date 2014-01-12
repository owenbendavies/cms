FactoryGirl.define do
  factory :page do
    site_id { Digest::MD5.hexdigest(rand.to_s) }
    name { Faker::Name.name }
    created_by { Digest::MD5.hexdigest(rand.to_s) }
    updated_by { Digest::MD5.hexdigest(rand.to_s) }
    html_content { "<p>#{ Faker::Lorem.paragraph }</p>" }
  end
end
