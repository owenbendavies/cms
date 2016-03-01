# == Schema Information
#
# Table name: sites
#
#  id                   :integer          not null, primary key
#  host                 :string(64)       not null
#  name                 :string(64)       not null
#  sub_title            :string(64)
#  layout               :string(32)       default("one_column"), not null
#  copyright            :string(64)
#  google_analytics     :string(32)
#  charity_number       :string(32)
#  stylesheet_filename  :string(40)
#  sidebar_html_content :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  main_menu_in_footer  :boolean          default(FALSE), not null
#  separate_header      :boolean          default(TRUE), not null
#  facebook             :string(64)
#  twitter              :string(15)
#  linkedin             :string(32)
#  github               :string(32)
#  youtube              :string(32)
#
# Indexes
#
#  index_sites_on_host  (host) UNIQUE
#

class SitesController < ApplicationController
  def index
    authorize Site
    @sites = current_user.sites
  end

  def edit
    authorize @site
  end

  def update
    authorize @site

    if @site.update_attributes site_params
      flash.notice = t('flash.updated', name: Site.model_name.human)
      redirect_to page_path('home')
    else
      render :edit
    end
  end

  alias css edit

  private

  def site_params
    params.require(:site).permit(
      :charity_number, :copyright, :css, :facebook, :github, :google_analytics,
      :layout, :linkedin, :main_menu_in_footer, :name, :separate_header,
      :sub_title, :twitter, :youtube
    )
  end
end
