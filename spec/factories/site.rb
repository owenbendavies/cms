FactoryGirl.define do
  factory :site do
    host { Faker::Internet.domain_name }
    name { Faker::Company.name.gsub("'", '') }
    sub_title { Faker::Company.catch_phrase }
    asset_host { "http://#{Faker::Internet.domain_name}" }
    copyright { Faker::Name.name }
    google_analytics { "UA-#{Faker::Number.number(3)}-#{Faker::Number.digit}" }
    charity_number { Faker::Number.number(Faker::Number.digit.to_i) }
    stylesheet_filename { "#{Digest::MD5.hexdigest(rand.to_s)}.css" }
    header_image_filename { "#{Digest::MD5.hexdigest(rand.to_s)}.png" }
    sidebar_html_content { "<h2>#{ Faker::Lorem.sentence }</h2>" }
    association :created_by, factory: :account
    association :updated_by, factory: :account

    after(:create) do |site|
      site.accounts += [site.created_by, site.updated_by]
    end
  end
end
