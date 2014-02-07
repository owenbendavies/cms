class SitesController < ApplicationController
  before_filter :login_required
  before_filter :edit_css_feature, only: [:css]

  def edit
  end

  def update
    if @site.update_attributes site_params
      flash[:success] = t('flash.updated', name: Site.model_name.human)
      redirect_to page_path('home')
    else
      render :edit
    end
  end

  alias_method :css, :edit

  private

  def site_params
    params.require(:site).permit(
      :name,
      :sub_title,
      :copyright,
      :google_analytics,
      :css
    ).merge(updated_by: user.id)
  end

  def edit_css_feature
    return page_not_found unless feature.edit_css
  end
end
