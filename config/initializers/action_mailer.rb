ActionMailer::Base.smtp_settings = {
  address: Rails.application.secrets.smtp_address,
  port: Rails.application.secrets.smtp_port,
  authentication: :plain,
  user_name: Rails.application.secrets.smtp_username,
  password: Rails.application.secrets.smtp_password,
  domain: `hostname -f`.strip
}
