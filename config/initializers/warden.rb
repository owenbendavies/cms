Rails.configuration.middleware.use RailsWarden::Manager do |manager|
  manager.default_strategies :password

  manager.failure_app = lambda { |env|
    SessionsController.action(:new).call(env)
  }
end

# Setup Session Serialization
class Warden::SessionSerializer
  def serialize(user)
    user.id
  end

  def deserialize(id)
    user = User.find_by_id(id)
    return unless user

    request = Rack::Request.new(env)

    if user.sites.map(&:host).include? request.host
      return user
    else
      return nil
    end
  end
end

# Strategies
Warden::Strategies.add(:password) do
  def authenticate!
    email = params['user']['email']
    password = params['user']['password']

    user = User.find_and_authenticate(email, password, request.host)

    if user
      success! user
    else
      fail! 'sessions.new.flash.invalid_login'
    end
  end
end
