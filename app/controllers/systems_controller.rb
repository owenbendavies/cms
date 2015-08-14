class SystemsController < ApplicationController
  PUBLIC_PAGES = [:health, :home, :loader_io, :robots, :sitemap, :timeout]

  skip_before_action :render_site_not_found, only: [:health]
  skip_before_action :authenticate_user!, only: PUBLIC_PAGES
  skip_authorization_check only: PUBLIC_PAGES

  def health
    respond_to do |format|
      format.text { render text: 'ok' }
    end
  end

  def home
    redirect_to page_path('home')
  end

  def loader_io
    respond_to do |format|
      format.text { render text: Rails.application.secrets.loaderio_token }
    end
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

  def timeout
    sleep params[:seconds].to_f
    render text: 'ok'
  end

  private

  def xml_sitemap
    XmlSitemap::Map.new(@site.host, home: false, secure: request.ssl?) do |map|
      @pages.each do |page|
        next if page.private?
        map.add page_path(page.to_param), updated: page.updated_at
      end
    end
  end
end
