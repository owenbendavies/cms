ActionMailer::Base.smtp_settings = {
  user_name: ENV['SMTP_USERNAME'],
  password: ENV['SMTP_PASSWORD'],
  address: ENV['SMTP_ADDRESS'],
  port: ENV['SMTP_PORT'].to_i,
  authentication: :plain,
  domain: `hostname -f`.strip,
}
