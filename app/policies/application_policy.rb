class ApplicationPolicy
  module Shared
    protected

    def user_logged_in?
      @site.present? && @user.present?
    end

    def user_is_admin?
      user_logged_in? && @user.groups.include?('admin')
    end
  end

  class Scope
    include Shared

    def initialize(context, scope)
      @user = context[:user]
      @site = context[:site]
      @scope = scope
    end

    def resolve
      @scope.where(site_id: @site.id)
    end
  end

  include Shared

  def initialize(context, record)
    @user = context[:user]
    @site = context[:site]
    @record = record
  end

  private

  def site_record?
    @site && @record.site_id == @site.id
  end

  def user_record?
    site_record? && user_logged_in?
  end
end
