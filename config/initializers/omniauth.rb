OmniAuth.config.logger = Rails.logger

OmniAuth.config.test_mode = true if ENV['AWS_STUB'].present?

OmniAuth.config.allowed_request_methods = %i[get post]
OmniAuth.config.silence_get_warning = true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :cognito_idp,
    ENV.fetch('AWS_COGNITO_CLIENT_ID'),
    ENV.fetch('AWS_COGNITO_CLIENT_SECRET'),
    aws_region: ENV.fetch('AWS_REGION'),
    client_options: {
      site: ENV.fetch('AWS_COGNITO_DOMAIN')
    },
    user_pool_id: ENV.fetch('AWS_COGNITO_USER_POOL_ID')
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
