class HealthPolicy < ApplicationPolicy
  def status?
    true
  end
end
