module Admin
  class StylesheetsController < ApplicationController
    before_action :authorize_css, only: %i[edit update]

    def edit; end

    def update
      @site.update! stylesheet_params
      flash.notice = t('flash.updated', name: Site.model_name.human)
      redirect_to page_path('home')
    end

    private

    def authorize_css
      authorize @site, :css?
    end

    def stylesheet_params
      params.require(:site).permit(:css)
    end
  end
end
