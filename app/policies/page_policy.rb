class PagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user_site?
        @scope.where(site_id: @site.id)
      else
        @scope.where(site_id: @site.id).visible
      end
    end
  end

  def index?
    true
  end

  def show?
    @record.private? ? user_record? : site_record?
  end

  def contact_form?
    show?
  end

  def create?
    user_record?
  end

  def update?
    user_record?
  end

  def destroy?
    user_record?
  end
end
