OmniAuth.config.logger = Rails.logger

OmniAuth.config.test_mode = true if ENV['AWS_STUB'].present?

OmniAuth.config.allowed_request_methods = %i[get post]
OmniAuth.config.silence_get_warning = true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :cognito_idp,
    Rails.configuration.x.aws_cognito_client_id,
    ENV.fetch('AWS_COGNITO_CLIENT_SECRET'),
    aws_region: ENV.fetch('AWS_REGION'),
    client_options: {
      site: Rails.configuration.x.aws_cognito_domain
    },
    user_pool_id: Rails.configuration.x.aws_cognito_user_pool_id
  )
end

if ENV['AWS_STUB'].present? && Rails.env.development?
  OmniAuth.config.mock_auth[:'cognito-idp'] = OmniAuth::AuthHash.new(
    'uid' => SecureRandom.uuid,
    'info' => {
      'name' => 'Test User',
      'email' => 'test@example.com'
    },
    'extra' => {
      'raw_info' => {
        'cognito:groups' => %w[localhost admin]
      }
    }
  )
end
