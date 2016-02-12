class SystemsController < ApplicationController
  PUBLIC_PAGES = [:health, :home, :robots, :sitemap].freeze

  skip_before_action :render_site_not_found, only: [:health]
  skip_before_action :authenticate_user!, only: PUBLIC_PAGES
  skip_authorization_check only: PUBLIC_PAGES

  def error_500
    authorize! :error_500, :system
    fail 'Test 500 error'
  end

  def error_delayed
    authorize! :error_delayed, :system
    Kernel.delay(queue: 'default').fail('Test delayed error')
    render text: 'Delayed error sent'
  end

  def error_timeout
    authorize! :error_timeout, :system
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

  def xml_sitemap
    XmlSitemap::Map.new(@site.host, home: false, secure: true) do |map|
      @pages.each do |page|
        next if page.private?
        map.add page_path(page.to_param), updated: page.updated_at
      end
    end
  end
end
