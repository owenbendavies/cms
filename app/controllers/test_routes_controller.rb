class TestRoutesController < ApplicationController
  def timeout
    sleep Float(params[:seconds])
    render text: 'ok'
  end
end
