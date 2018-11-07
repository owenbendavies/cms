class MessagePolicy < ApplicationPolicy
  def index?
    user_logged_in?
  end
end
