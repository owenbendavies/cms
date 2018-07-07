require 'rails_helper'

RSpec.describe 'Logout' do
  context 'with GET /logout' do
    let(:request_user) { FactoryBot.build(:user) }
    let(:expected_status) { 302 }
    let(:cognito_domain) { Faker::Internet.url }

    let(:environment_variables) do
      {
        'AWS_COGNITO_DOMAIN' => cognito_domain
      }
    end

    let(:expected_url) do
      "#{cognito_domain}/logout?client_id=xxxx&logout_uri=http%3A%2F%2F#{site.host}%2F"
    end

    it 'redirects to AWS cognito' do
      request_page
      expect(response.redirect_url).to eq expected_url
    end
  end
end
