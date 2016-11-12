class ApplicationPolicy
  def initialize(context, record)
    @user = context[:user]
    @site = context[:site]
    @record = record
  end

  def new?
    create?
  end

  def edit?
    update?
  end

  protected

  def user_site?
    @user && @user.site_settings.find_by(site_id: @site.id)
  end

  def user_record?
    @user && @user.site_settings.find_by(site_id: @record.site_id)
  end
end
