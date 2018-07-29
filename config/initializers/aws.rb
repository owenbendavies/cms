AWS_CONFIG = { stub_responses: ENV['AWS_STUB'].present? }.freeze

AWS_COGNITO = Aws::CognitoIdentityProvider::Client.new(AWS_CONFIG)

if ENV['AWS_STUB'].present? && Rails.env.development?
  AWS_COGNITO_USER_DATA = [
    {
      'attributes' => [
        { 'name' => 'email', 'value' => 'test@example.com' }
      ]
    }
  ].freeze

  AWS_COGNITO.stub_responses(
    :list_users_in_group,
    AWS_COGNITO.stub_data(:list_users_in_group, users: AWS_COGNITO_USER_DATA)
  )
end
