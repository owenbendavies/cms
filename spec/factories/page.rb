FactoryGirl.define do
  factory :page do
    site_id { Digest::MD5.hexdigest(rand.to_s) }
    name { Faker::Name.name }
    created_by { Digest::MD5.hexdigest(rand.to_s) }
    updated_by { Digest::MD5.hexdigest(rand.to_s) }
    updated_from { Faker::Internet.ip_v4_address }
    html_content { "<p>#{ Faker::Lorem.paragraph }</p>" }
  end
end
