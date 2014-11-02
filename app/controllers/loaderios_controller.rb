class LoaderiosController < ApplicationController
  skip_before_filter :login_required

  def show
    respond_to do |format|
      format.text { render text: Rails.application.secrets.loaderio_token }
    end
  end
end
