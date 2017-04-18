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

  def css?
    @user && @user.site_settings.find_by(site_id: @record.id, admin: true)
  end
end
