class UserPolicy < ApplicationPolicy
  def index?
    user_site?
  end

  def create?
    user_site?
  end
end
