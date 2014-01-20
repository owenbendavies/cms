class TestRoutesController < ApplicationController
  def timeout
    sleep params[:seconds].to_f
    render text: 'ok'
  end
end
