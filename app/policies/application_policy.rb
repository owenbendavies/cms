class ApplicationPolicy
  module Shared
    protected

    def user_site?
      @site && @user&.groups&.include?(@site.host)
    end

    def admin_site?
      user_site? && @user&.groups&.include?('admin')
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

  def new?
    create?
  end

  def edit?
    update?
  end

  private

  def site_record?
    @site && @record.site_id == @site.id
  end

  def user_record?
    site_record? && user_site?
  end
end
