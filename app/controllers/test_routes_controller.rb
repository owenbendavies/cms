class TestRoutesController < ApplicationController
  skip_before_action :authenticate_user!

  def timeout
    sleep params[:seconds].to_f
    render text: 'ok'
  end
end
