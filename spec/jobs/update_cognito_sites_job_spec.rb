require 'rails_helper'

RSpec.describe UpdateCognitoSitesJob do
  let(:create_group_options) do
    {
      group_name: site.host,
      user_pool_id: ENV.fetch('AWS_COGNITO_USER_POOL_ID')
    }
  end

  let(:delete_group_options) do
    {
      group_name: 'localhost',
      user_pool_id: ENV.fetch('AWS_COGNITO_USER_POOL_ID')
    }
  end

  let!(:site) { FactoryBot.create(:site) }

  it 'creates missing cognito groups' do
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
