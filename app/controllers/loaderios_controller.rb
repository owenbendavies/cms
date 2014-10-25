class LoaderiosController < ApplicationController
  skip_before_filter :login_required

  def show
    respond_to do |format|
      format.text { render text: ENV['LOADERIO_VERIFICATION_TOKEN'] }
    end
  end
end
