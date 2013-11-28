class SitemapController < ApplicationController
  skip_before_filter :check_format_is_nil
  before_filter :check_format

  def show
    @pages = Page.find_all_links_by_site(@site)

    respond_to do |format|
      format.html
      format.xml { render xml: sitemap.render }
    end
  end

  private

  def check_format
    page_not_found unless params[:format].nil? or params[:format] == 'xml'
  end

  def sitemap
    XmlSitemap::Map.new(@site.host, home: false) do |map|
      @pages.each do |page|
        next if page.private
        map.add page_path(page.url), updated: page.updated_at
      end
    end
  end
end
