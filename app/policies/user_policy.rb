class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      @site.users
    end
  end

  def index?
    user_site?
  end

  def create?
    user_site?
  end
end
