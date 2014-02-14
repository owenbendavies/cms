ActionMailer::Base.smtp_settings = {
  address: ENV['SMTP_ADDRESS'],
  port: ENV['SMTP_PORT'].to_i,
  authentication: :plain,
  user_name: (ENV['SMTP_USERNAME'] || ENV['SENDGRID_USERNAME']),
  password: (ENV['SMTP_PASSWORD'] || ENV['SENDGRID_PASSWORD']),
  domain: `hostname -f`.strip,
}
