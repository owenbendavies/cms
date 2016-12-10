class ApplicationPolicy
  module Shared
    protected

    def user_site?
      @user && @user.site_settings.find_by(site_id: @site.id)
    end

    def user_record?
      @user && @user.site_settings.find_by(site_id: @record.site_id)
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
end
