if ENV['SENDGRID_USERNAME'] && ENV['SENDGRID_PASSWORD']
  ActionMailer::Base.smtp_settings = {
    address: 'smtp.sendgrid.net',
    port: 587,
    user_name: ENV.fetch('SENDGRID_USERNAME'),
    password: ENV.fetch('SENDGRID_PASSWORD')
  }
elsif ENV['AWS_REGION'] && ENV['AWS_ACCESS_KEY_ID'] && ENV['AWS_SECRET_ACCESS_KEY']
  signature = OpenSSL::HMAC.digest(
    OpenSSL::Digest.new('sha256'),
    ENV.fetch('AWS_SECRET_ACCESS_KEY'),
    'SendRawEmail'
  )

  ActionMailer::Base.smtp_settings = {
    address: "email-smtp.#{ENV.fetch('AWS_REGION')}.amazonaws.com",
    port: 587,
    user_name: ENV.fetch('AWS_ACCESS_KEY_ID'),
    password: Base64.encode64(2.chr + signature).strip
  }
end
