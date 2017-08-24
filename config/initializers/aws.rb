if ENV['AWS_REGION'] && ENV['AWS_ACCESS_KEY_ID'] && ENV['AWS_SECRET_ACCESS_KEY']
  AWS_CREDENTIALS = Aws::Credentials.new(
    ENV.fetch('AWS_ACCESS_KEY_ID'),
    ENV.fetch('AWS_SECRET_ACCESS_KEY')
  )

  AWS_SNS_CLIENT = Aws::SNS::Client.new(
    credentials: AWS_CREDENTIALS,
    region: ENV.fetch('AWS_REGION')
  )
end
