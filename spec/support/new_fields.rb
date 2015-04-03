module NewFields
  extend ActiveSupport::Concern

  included do
    let(:new_catch_phrase) { Faker::Company.catch_phrase }
    let(:new_company_name) { Faker::Company.name.gsub("'", '') }
    let(:new_email) { Faker::Internet.email }

    let(:new_google_analytics) do
      "UA-#{Faker::Number.number(3)}-#{Faker::Number.digit}"
    end

    let(:new_host) { Faker::Internet.domain_name }
    let(:new_message) { Faker::Lorem.paragraph }
    let(:new_name) { Faker::Name.name }
    let(:new_password) { Faker::Internet.password(20, 30) }
    let(:new_phone) { "+447#{rand(1_000_000_000).to_s.ljust(9, '0')}" }
    let(:new_number) { rand 10_000 }

    let(:new_facebook) { Faker::Internet.user_name(nil, ['.']) }
    let(:new_twitter) { Faker::Internet.user_name(nil, ['_'])[0, 15] }
    let(:new_linkedin) { Faker::Internet.user_name }
    let(:new_github) { Faker::Internet.user_name }
  end
end

RSpec.configuration.include NewFields
