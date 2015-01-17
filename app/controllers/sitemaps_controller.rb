class SitemapsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @pages = @site.pages

    respond_to do |format|
      format.html
      format.xml { render xml: sitemap.render }
    end
  end

  private

  def sitemap
    XmlSitemap::Map.new(@site.host, home: false, secure: request.ssl?) do |map|
      @pages.each do |page|
        next if page.private?
        map.add page_path(page.url), updated: page.updated_at
      end
    end
  end
end
