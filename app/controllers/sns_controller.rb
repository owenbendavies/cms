class SnsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[message]
  skip_after_action :verify_authorized, only: %i[message]

  def message
    SnsNotification.from_message(request.raw_post)
    head :no_content
  end
end
