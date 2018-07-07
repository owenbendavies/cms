module Admin
  class MessagesController < ApplicationController
    def index
      authorize Message
    end

    def show
      @message = @site.messages.find_by!(uid: params[:id])
      authorize @message
    end
  end
end
