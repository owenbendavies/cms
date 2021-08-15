class CssController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]
  skip_after_action :verify_authorized, only: %i[show]

  def show
    if @site.css
      expires_in 1.year, public: true

      respond_to do |format|
        format.css { render plain: @site.css }
      end
    else
      respond_to do |format|
        format.css { head :not_found }
      end
    end
  end
end
