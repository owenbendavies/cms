class SitePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      Site.where(host: @user.groups)
    end
  end

  def index?
    @user.present?
  end

  def update?
    user_logged_in?
  end

  def css?
    user_is_admin?
  end
end
