class SystemsController < ApplicationController
  PUBLIC_PAGES = %i[health home robots].freeze

  skip_before_action :render_site_not_found, only: [:health]
  skip_before_action :authenticate_user!, only: PUBLIC_PAGES
  skip_after_action :verify_authorized, only: PUBLIC_PAGES

  def error_500
    authorize :errors
    raise 'Test 500 error'
  end

  def error_timeout
    authorize :errors
    sleep Rack::Timeout.service_timeout + 1
  end

  def health
    respond_to do |format|
      format.text { render plain: 'ok' }
    end
  end

  def home
    redirect_to page_path('home')
  end

  def robots; end
end
