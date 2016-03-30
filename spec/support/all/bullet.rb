RSpec.configure do |config|
  config.before :each do
    Bullet.start_request
  end

  config.after :each do
    Bullet.end_request
  end
end
