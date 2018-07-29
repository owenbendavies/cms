class SystemPolicy < ApplicationPolicy
  def health?
    true
  end

  def test_500_error?
    sysadmin?
  end

  def test_delayed_error?
    sysadmin?
  end

  def test_timeout_error?
    sysadmin?
  end
end
