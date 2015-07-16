class MessagesController < ApplicationController
  def index
    @messages = @site.messages
  end

  def show
    @message = @site.messages.find_by_id!(params[:id])
  end
end
