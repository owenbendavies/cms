class SystemPolicy < ApplicationPolicy
  def error_500?
    @user.sysadmin?
  end

  def error_delayed?
    @user.sysadmin?
  end

  def error_timeout?
    @user.sysadmin?
  end
end
