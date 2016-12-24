require 'rails_helper'

RSpec.describe 'Rollbar', type: :request do
  let(:rollbar_config) { 'rollbarConfig' }

  context 'without token' do
    it 'does not contain Rollbar js' do
      get '/home'

      expect(body).not_to include rollbar_config
    end
  end

  context 'with token' do
    let(:rollbar_client_token) { 'xxxxx' }

    around do |example|
      ClimateControl.modify(ROLLBAR_CLIENT_TOKEN: rollbar_client_token) do
        example.run
      end
    end

    it 'contains Rollbar js with token' do
      get '/home'

      expect(body).to include rollbar_config
      expect(body).to include "accessToken: \"#{rollbar_client_token}\""
    end
  end
end
