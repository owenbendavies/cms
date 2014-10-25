class StylesheetsController < ApplicationController
  skip_before_filter :render_site_not_found
  skip_before_filter :login_required
  before_filter :find_css_site

  def show
    expires_in 1.year, public: true

    respond_to do |format|
      format.css { render text: @css_site.css }
    end
  end

  private

  def find_css_site
    @css_site = Site.find_by_css_filename("#{params[:id]}.css")
    return page_not_found unless @css_site
  end
end
