AWS_CONFIG = { stub_responses: ENV['AWS_STUB'].present? }.freeze

AWS_COGNITO = Aws::CognitoIdentityProvider::Client.new(AWS_CONFIG)

if ENV['AWS_STUB'].present? && !Rails.env.production?
  AWS_COGNITO.stub_responses(
    :list_users_in_group,
    AWS_COGNITO.stub_data(
      :list_users_in_group,
      JSON.parse(
        Rails.root.join('spec', 'support', 'stubs', 'aws_cognito_list_users_in_group.json').read
      )
    )
  )
end
