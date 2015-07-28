class SitesController < ApplicationController
  def index
    authorize! :index, Site
  end

  def edit
    authorize! :edit, @site
  end

  def update
    authorize! :update, @site

    if @site.update_attributes site_params
      flash.notice = t('flash.updated', name: Site.model_name.human)
      redirect_to page_path('home')
    else
      render :edit
    end
  end

  alias_method :css, :edit

  private

  def site_params
    params.require(:site).permit(
      :charity_number, :copyright, :css, :facebook, :github, :google_analytics,
      :layout, :linkedin, :main_menu_in_footer, :name, :separate_header,
      :sub_title, :twitter, :youtube
    ).merge(updated_by: current_user)
  end
end
