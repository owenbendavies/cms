require 'rails_helper'

RSpec.describe 'Rollbar', type: :request do
  let(:rollbar_config) { 'rollbarConfig' }

  before { request_page }

  context 'without a token' do
    it 'does not contain Rollbar js' do
      expect(body).not_to include rollbar_config
    end
  end

  context 'with a token' do
    let(:rollbar_client_token) { 'xxxxx' }

    around do |example|
      ClimateControl.modify(ROLLBAR_CLIENT_TOKEN: rollbar_client_token) do
        example.run
      end
    end

    it 'contains Rollbar js' do
      expect(body).to include rollbar_config
    end

    it 'contains Rollbar token' do
      expect(body).to include "accessToken: \"#{rollbar_client_token}\""
    end
  end
end
