module Admin
  class StylesheetsController < ApplicationController
    before_action :authorize_stylesheet, only: %i[edit update]
    before_action :find_stylesheet, only: %i[edit update]

    def edit; end

    def update
      @stylesheet.update! stylesheet_params
      flash.notice = t('flash.updated', name: Stylesheet.model_name.human)
      redirect_to page_path('home')
    end

    private

    def authorize_stylesheet
      authorize Stylesheet
    end

    def find_stylesheet
      @stylesheet = Stylesheet.where(site: @site).first_or_initialize
    end

    def stylesheet_params
      params.require(:stylesheet).permit(:css)
    end
  end
end
