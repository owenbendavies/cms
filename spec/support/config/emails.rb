RSpec.configure do |config|
  config.before do
    ActionMailer::Base.deliveries = []
  end

  config.after do
    raise 'Emails not processed' unless ActionMailer::Base.deliveries.empty?
  end
end
