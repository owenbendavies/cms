module NewFields
  extend ActiveSupport::Concern

  included do
    let(:new_catch_phrase) { Faker::Company.catch_phrase }
    let(:new_company_name) { Faker::Company.name.delete("'") }
    let(:new_email) { Faker::Internet.email }

    let(:new_message) { Faker::Lorem.paragraph }
    let(:new_name) { Faker::Name.name }
    let(:new_password) { Faker::Internet.password(20, 30) }
    let(:new_phone) { "+447819#{rand(100_000).to_s.ljust(6, '0')}" }
    let(:new_number) { rand 10_000 }
  end
end

RSpec.configuration.include NewFields
