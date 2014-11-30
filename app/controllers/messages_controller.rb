class MessagesController < ApplicationController
  def index
    @messages = @site.messages
  end

  def show
    @message = Message.find_by_site_id_and_id!(@site, params[:id])
  end
end
