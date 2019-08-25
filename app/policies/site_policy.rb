class SitePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user_is_admin?
        @scope.all
      else
        @scope.where(host: @user.groups)
      end
    end
  end

  def update?
    user_logged_in?
  end
end
