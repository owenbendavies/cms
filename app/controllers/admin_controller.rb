class AdminController < ApplicationController
  skip_after_action :verify_authorized, only: %i[index]
  skip_after_action :verify_policy_scoped, only: %i[index]

  def index
    @admin_data = {
      awsCognitoUserPoolId: ENV.fetch('AWS_COGNITO_USER_POOL_ID'),
      awsCognitoClientId: ENV.fetch('AWS_COGNITO_CLIENT_ID')
    }
  end
end
