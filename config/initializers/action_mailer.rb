if Rails.env.test?
  Rails.application.config.action_mailer.delivery_method = :test
elsif Rails.env.development?
  Rails.application.config.action_mailer.delivery_method = :letter_opener
else
  Aws::Rails.add_action_mailer_delivery_method(:aws_sdk)

  Rails.application.config.action_mailer.delivery_method = :aws_sdk
end
