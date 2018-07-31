if Rails.env.test?
  Rails.application.config.action_mailer.delivery_method = :test
elsif ENV['SMTP_ADDRESS'] && ENV['SMTP_PORT']
  ActionMailer::Base.smtp_settings = {
    address: ENV.fetch('SMTP_ADDRESS'),
    port: Integer(ENV.fetch('SMTP_PORT'))
  }
else
  Aws::Rails.add_action_mailer_delivery_method(:aws_sdk)

  Rails.application.config.action_mailer.delivery_method = :aws_sdk
end
