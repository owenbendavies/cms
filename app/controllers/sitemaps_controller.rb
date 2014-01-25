class SitemapsController < ApplicationController
  def show
    @pages = Page.find_all_links_by_site(@site)

    respond_to do |format|
      format.html
      format.xml { render xml: sitemap.render }
    end
  end

  private

  def sitemap
    XmlSitemap::Map.new(@site.host, home: false) do |map|
      @pages.each do |page|
        next if page.private
        map.add page_path(page.url), updated: page.updated_at
      end
    end
  end
end
