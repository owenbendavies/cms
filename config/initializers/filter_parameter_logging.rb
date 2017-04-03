# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += %i[
  password
  password_confirmation
  unlock_token
  reset_password_token
  confirmation_token
  invitation_token
]
