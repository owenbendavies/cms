class LoaderiosController < ApplicationController
  def show
    respond_to do |format|
      format.text { render text: ENV['LOADERIO_VERIFICATION_TOKEN'] }
    end
  end
end
