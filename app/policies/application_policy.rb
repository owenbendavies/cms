class ApplicationPolicy
  module Shared
    protected

    def initialize(context, _)
      @user = context[:user]
      @site = context[:site]
    end

    def user_site?
      @site && @user&.site_settings&.find_by(site_id: @site.id)
    end
  end

  class Scope
    include Shared

    def initialize(context, scope)
      super
      @scope = scope
    end

    def resolve
      @scope.where(site_id: @site.id)
    end
  end

  include Shared

  def initialize(context, record)
    super
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
