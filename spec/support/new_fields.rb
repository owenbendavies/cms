module NewFields
  extend ActiveSupport::Concern

  included do
    def generate_md5
      Digest::MD5.hexdigest(rand.to_s)
    end

    let(:new_catch_phrase) { Faker::Company.catch_phrase }
    let(:new_company_name) { Faker::Company.name.gsub("'", '') }
    let(:new_email) { Faker::Internet.safe_email }

    let(:new_google_analytics) {
      "UA-#{Faker::Number.number(3)}-#{Faker::Number.digit}"
    }

    let(:new_host) { Faker::Internet.domain_name }
    let(:new_id) { generate_md5 }
    let(:new_message) { Faker::Lorem.paragraph }
    let(:new_name) { Faker::Name.name }
    let(:new_password) { 'Aq2%' + Faker::Lorem.words(3).join }
    let(:new_phone) { Faker::PhoneNumber.phone_number }
  end
end

RSpec.configuration.include NewFields
