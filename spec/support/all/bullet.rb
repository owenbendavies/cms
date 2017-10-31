RSpec.configure do |config|
  config.before do
    Bullet.start_request
  end

  config.after do
    Bullet.end_request
  end
end
