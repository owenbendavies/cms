class SystemsController < ApplicationController
  PUBLIC_PAGES = %i[home robots].freeze

  skip_before_action :authenticate_user!, only: PUBLIC_PAGES
  skip_after_action :verify_authorized, only: PUBLIC_PAGES

  def error_500
    authorize :test_errors
    raise 'Test 500 error'
  end

  def error_timeout
    authorize :test_errors
    sleep Rack::Timeout.service_timeout + 1
  end

  def home
    redirect_to page_path('home')
  end

  def robots; end
end
