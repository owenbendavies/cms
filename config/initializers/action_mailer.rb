case Rails.application.secrets.email_provider
when 'aws'
  signature = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), ENV['IAM_SECRET'], 'SendRawEmail')

  ActionMailer::Base.smtp_settings = {
    address: "email-smtp.#{ENV['AWS_REGION']}.amazonaws.com",
    port: 587,
    user_name: ENV['IAM_KEY'],
    password: Base64.encode64(2.chr + signature).strip
  }
when 'sendgrid'
  ActionMailer::Base.smtp_settings = {
    address: 'smtp.sendgrid.net',
    port: 587,
    user_name: ENV['SENDGRID_USERNAME'],
    password: ENV['SENDGRID_PASSWORD']
  }
when 'letter_opener'
  ActionMailer::Base.smtp_settings = {
    address: 'localhost',
    port: 1025
  }
end
