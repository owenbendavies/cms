Aws.config[:log_level] = :debug

AWS_CONFIG = { stub_responses: ENV['AWS_STUB'].present? }.freeze

AWS_COGNITO = Aws::CognitoIdentityProvider::Client.new(AWS_CONFIG)

if ENV['AWS_STUB'].present? && !Rails.env.production?
  LIST_USERS_IN_GROUP_ADMIN = AWS_COGNITO.stub_data(
    :list_users_in_group,
    JSON.parse(
      Rails.root.join('spec/support/stubs/aws_cognito_list_users_in_group_admin.json').read
    )
  )

  LIST_USERS_IN_GROUP_SITE = AWS_COGNITO.stub_data(
    :list_users_in_group,
    JSON.parse(
      Rails.root.join('spec/support/stubs/aws_cognito_list_users_in_group_site.json').read
    )
  )

  AWS_COGNITO.stub_responses(
    :list_users_in_group,
    lambda do |context|
      if context.params.fetch(:group_name) == 'admin'
        LIST_USERS_IN_GROUP_ADMIN
      else
        LIST_USERS_IN_GROUP_SITE
      end
    end
  )
end
