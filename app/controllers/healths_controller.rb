class HealthsController < ApplicationController
  skip_before_filter :render_site_not_found
  skip_before_filter :login_required

  def show
    respond_to do |format|
      format.text { render text: 'ok' }
    end
  end
end
