class ImagePolicy < ApplicationPolicy
  def index?
    user_site?
  end
end
