class MessagePolicy < ApplicationPolicy
  def index?
    user_site?
  end

  def show?
    user_record?
  end

  def destroy?
    user_record?
  end
end
