module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
  end

  def authenticate_user!
    page_not_found unless current_user
  end

  def current_user
    @current_user ||= User.new(session[:user]) if session[:user]
  end
end
