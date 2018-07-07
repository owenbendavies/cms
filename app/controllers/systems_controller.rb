class SystemsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[robots]
  skip_after_action :verify_authorized, only: %i[robots]

  def test_500_error
    authorize :system
    raise 'Test 500 error'
  end

  def test_timeout_error
    authorize :system
    sleep 30
  end

  def robots; end
end
