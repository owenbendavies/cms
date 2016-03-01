class SitePolicy < ApplicationPolicy
  def index?
    @user.present?
  end

  def update?
    user_site?
  end

  def css?
    @user.site_settings.find_by_site_id_and_admin(@record.id, true)
  end
end
