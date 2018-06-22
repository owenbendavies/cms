class CssController < ApplicationController
  skip_before_action :render_site_not_found, only: %i[show]
  skip_before_action :authenticate_user!, only: %i[show]
  skip_after_action :verify_authorized, only: %i[show]

  def show
    uid = params[:id].split('-').first
    site = Site.find_by!(uid: uid)
    stylesheet = Stylesheet.find_by!(site: site)

    expires_in 1.year, public: true

    respond_to do |format|
      format.css { render plain: stylesheet.css }
    end
  end
end
