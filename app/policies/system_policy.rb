class SystemPolicy < ApplicationPolicy
  def health?
    true
  end

  def test_500_error?
    @user&.sysadmin?
  end

  def test_delayed_error?
    @user&.sysadmin?
  end

  def test_timeout_error?
    @user&.sysadmin?
  end
end
