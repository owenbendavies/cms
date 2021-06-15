require 'rails_helper'

RSpec.describe 'Rollbar' do
  let(:request_method) { :get }
  let(:request_path) { '/sitemap' }
  let(:rollbar_config) { 'rollbarConfig' }
  let(:rollbar_js) { 'rollbarJsUrl' }

  context 'without token' do
    it 'does not contain Rollbar config' do
      request_page
      expect(body).not_to include rollbar_config
    end

    it 'does not contain Rollbar js' do
      request_page
      expect(body).not_to include rollbar_js
    end
  end

  context 'with token' do
    let(:rollbar_client_token) { 'xxxxx' }

    before do
      allow(Rails.configuration.x).to receive(:rollbar_client_token).and_return(rollbar_client_token)
    end

    it 'contains Rollbar config' do
      request_page
      expect(body).to include rollbar_config
    end

    it 'contains Rollbar js' do
      request_page
      expect(body).to include rollbar_js
    end

    it 'contains Rollbar token' do
      request_page
      expect(body).to include "accessToken: \"#{rollbar_client_token}\""
    end
  end
end
