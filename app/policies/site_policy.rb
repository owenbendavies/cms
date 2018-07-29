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
    user_site?
  end
end
