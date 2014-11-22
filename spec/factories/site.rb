FactoryGirl.define do
  factory :site do
    host 'localhost'
    name { Faker::Company.name.gsub("'", '') }
    sub_title { Faker::Company.catch_phrase }
    asset_host { "http://#{Faker::Internet.domain_name}" }
    copyright { Faker::Name.name }
    google_analytics { "UA-#{Faker::Number.number(3)}-#{Faker::Number.digit}" }
    charity_number { Faker::Number.number(Faker::Number.digit.to_i) }
    updated_by { Digest::MD5.hexdigest(rand.to_s) }
    header_image_filename { "#{Digest::MD5.hexdigest(rand.to_s)}.png" }
    sidebar_html_content { "<h2>#{ Faker::Lorem.sentence }</h2>" }
  end
end
