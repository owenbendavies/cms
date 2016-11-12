class SitePolicy < ApplicationPolicy
  def index?
    @user.present?
  end

  def update?
    user_site?
  end

  def css?
    @user.site_settings.find_by(site_id: @record.id, admin: true)
  end
end
