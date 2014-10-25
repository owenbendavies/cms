class SessionsController < ApplicationController
  skip_before_filter :login_required

  def new
    flash.now[:error] = t(warden.message) if warden.message
  end

  def create
    authenticate!
    home
  end

  def destroy
    logout
    home
  end
end
