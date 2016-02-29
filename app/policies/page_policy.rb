class PagePolicy < ApplicationPolicy
  def show?
    !@record.private? || user_record?
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
