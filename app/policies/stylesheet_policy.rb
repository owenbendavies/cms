class StylesheetPolicy < ApplicationPolicy
  def update?
    admin_site?
  end
end
