class SystemsController < ApplicationController
  PUBLIC_PAGES = [:health, :home, :robots, :sitemap].freeze

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
    sleep Integer(Rails.application.secrets.timeout) + 1
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

  def sitemap
    @pages = @site.pages

    respond_to do |format|
      format.html
      format.xml { render xml: xml_sitemap.render }
    end
  end

  private

  def authorize_user
    authorize :system
  end

  def xml_sitemap
    XmlSitemap::Map.new(@site.host, home: false, secure: true) do |map|
      @pages.non_private.each do |page|
        map.add page_path(page.to_param), updated: page.updated_at
      end
    end
  end
end
