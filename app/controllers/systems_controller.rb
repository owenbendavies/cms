class SystemsController < ApplicationController
  PUBLIC_PAGES = [:health, :home, :robots].freeze

  skip_before_action :render_site_not_found, only: [:health]
  skip_before_action :authenticate_user!, only: PUBLIC_PAGES
  skip_after_action :verify_authorized, only: PUBLIC_PAGES
  before_action :authorize_user, except: PUBLIC_PAGES

  def error_500
    raise 'Test 500 error'
  end

  def error_delayed
    Kernel.delay(queue: 'default').fail('Test delayed error')
    render text: 'Delayed error sent'
  end

  def error_timeout
    sleep Rack::Timeout.service_timeout + 1
  end

  def health
    respond_to do |format|
      format.text { render text: 'ok' }
    end
  end

  def home
    redirect_to page_path('home')
  end

  def robots
  end

  private

  def authorize_user
    authorize :system
  end
end
