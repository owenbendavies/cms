require 'rails_helper'

RSpec.describe UpdateCognitoSitesJob do
  let(:update_user_pool_client_options) do
    {
      allowed_o_auth_flows: ['code'],
      allowed_o_auth_flows_user_pool_client: true,
      allowed_o_auth_scopes: ['openid'],
      callback_urls: ['http://www.example.com:37511/auth/cognito-idp/callback'],
      client_id: ENV.fetch('AWS_COGNITO_CLIENT_ID'),
      logout_urls: ['http://www.example.com:37511/'],
      supported_identity_providers: ['COGNITO'],
      user_pool_id: ENV.fetch('AWS_COGNITO_USER_POOL_ID')
    }
  end

  let(:create_group_options) do
    {
      group_name: 'www.example.com',
      user_pool_id: ENV.fetch('AWS_COGNITO_USER_POOL_ID')
    }
  end

  let(:delete_group_options) do
    {
      group_name: 'localhost',
      user_pool_id: ENV.fetch('AWS_COGNITO_USER_POOL_ID')
    }
  end

  it 'updates AWS cognito sites' do
    FactoryBot.create(:site, host: 'www.example.com')

    expect(AWS_COGNITO).to receive(:update_user_pool_client)
      .with(update_user_pool_client_options)
      .and_call_original

    described_class.perform_now
  end

  it 'creates missing cognito groups' do
    FactoryBot.create(:site, host: 'www.example.com')

    expect(AWS_COGNITO).to receive(:create_group)
      .with(create_group_options)
      .and_call_original

    described_class.perform_now
  end

  it 'deletes extra cognito groups' do
    expect(AWS_COGNITO).to receive(:delete_group)
      .with(delete_group_options)
      .and_call_original

    described_class.perform_now
  end
end
