class TestRoutesController < ApplicationController
  skip_before_action :authenticate_user!
  skip_authorization_check

  def timeout
    sleep params[:seconds].to_f
    render text: 'ok'
  end
end
