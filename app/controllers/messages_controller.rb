class MessagesController < ApplicationController
  def index
    @messages = Message.find_all_by_site(@site)
  end

  def show
    @message = Message.find_by_site_and_id(@site, params[:id])
    return page_not_found unless @message
  end
end
