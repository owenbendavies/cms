class TestRoutesController < ApplicationController
  skip_before_filter :login_required

  def timeout
    sleep params[:seconds].to_f
    render text: 'ok'
  end
end
