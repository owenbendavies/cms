class StylesheetPolicy < ApplicationPolicy
  def update?
    user_is_admin?
  end
end
