class SnsController < ApplicationController
  skip_before_action :render_site_not_found, only: %i[message]
  skip_before_action :authenticate_user!, only: %i[message]

  def message
    authorize :sns, :create?
    SnsNotification.from_message(request.raw_post)
    head :no_content
  end
end
