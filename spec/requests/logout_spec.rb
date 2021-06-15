require 'rails_helper'

RSpec.describe 'Logout' do
  context 'with GET /logout' do
    let(:request_user) { FactoryBot.build(:user) }
    let(:expected_status) { 302 }
    let(:cognito_domain) { Faker::Internet.url }

    let(:expected_url) do
      "#{cognito_domain}/logout?client_id=xxxx&logout_uri=http%3A%2F%2F#{site.host}%2F"
    end

    before do
      allow(Rails.configuration.x).to receive(:aws_cognito_domain).and_return(cognito_domain)
    end

    it 'redirects to AWS cognito' do
      request_page
      expect(response.redirect_url).to eq expected_url
    end
  end
end
