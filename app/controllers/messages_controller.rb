class MessagesController < ApplicationController
  authorize_resource :site
  load_and_authorize_resource through: :site

  def index
    @messages = @messages.paginate(page: params[:page])
  end

  def show
  end
end
