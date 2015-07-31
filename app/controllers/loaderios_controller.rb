class LoaderiosController < ApplicationController
  skip_before_action :authenticate_user!
  skip_authorization_check

  def show
    respond_to do |format|
      format.text { render text: Rails.application.secrets.loaderio_token }
    end
  end
end
