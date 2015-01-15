class SessionsController < ApplicationController
  skip_before_action :login_required

  def new
    flash.alert = t(warden.message) if warden.message
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
