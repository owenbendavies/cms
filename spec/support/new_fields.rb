module NewFields
  def generate_md5
    Digest::MD5.hexdigest(rand.to_s)
  end

  RSpec.shared_context 'new_fields' do
    let(:new_catch_phrase) { Faker::Company.catch_phrase }
    let(:new_company_name) { Faker::Company.name.gsub("'", '') }
    let(:new_email) { Faker::Internet.safe_email }
    let(:new_filename) { "#{generate_md5}.jpg" }

    let(:new_google_analytics) {
      "UA-#{Faker::Number.number(3)}-#{Faker::Number.digit}"
    }

    let(:new_host) { Faker::Internet.domain_name }
    let(:new_id) { generate_md5 }
    let(:new_message) { Faker::Lorem.paragraph }
    let(:new_name) { Faker::Name.name }
    let(:new_number) { Faker::Number.number(Faker::Number.digit.to_i) }
    let(:new_page_url) { Faker::Internet.slug(nil, '_') }
    let(:new_password) { Faker::Lorem.words(4).join }
    let(:new_phone_number) { Faker::PhoneNumber.phone_number }
    let(:new_url) { Faker::Internet.url }
  end
end

RSpec.configuration.include NewFields
