class MessagesController < ApplicationController
  def index
    authorize Message
    @messages = policy_scope(Message).ordered.paginate(page: params[:page])
  end

  def show
    @message = @site.messages.find_by!(uuid: params[:id])
    authorize @message
  end
end
