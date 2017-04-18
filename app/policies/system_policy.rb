class SystemPolicy < ApplicationPolicy
  def error_500?
    @user && @user.sysadmin?
  end

  def error_delayed?
    @user && @user.sysadmin?
  end

  def error_timeout?
    @user && @user.sysadmin?
  end
end
