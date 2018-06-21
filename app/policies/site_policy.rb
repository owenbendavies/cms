class SitePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      @user.sites
    end
  end

  def index?
    @user.present?
  end

  def update?
    user_site?
  end
end
