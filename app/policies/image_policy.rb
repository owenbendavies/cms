class ImagePolicy < ApplicationPolicy
  def index?
    user_logged_in?
  end
end
