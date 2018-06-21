module Admin
  class SitesController < ApplicationController
    def index
      authorize Site
      @sites = policy_scope(Site).ordered
    end

    def edit
      authorize @site
    end

    def update
      authorize @site

      if @site.update site_params
        flash.notice = t('flash.updated', name: Site.model_name.human)
        redirect_to page_path('home')
      else
        render :edit
      end
    end

    private

    def site_params
      params.require(:site).permit(
        :charity_number, :google_analytics, :main_menu_in_footer, :name,
        :separate_header, :privacy_policy_page_id
      )
    end
  end
end
