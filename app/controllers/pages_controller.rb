# == Schema Information
#
# Table name: pages
#
#  id                 :integer          not null, primary key
#  site_id            :integer          not null
#  url                :string(64)       not null
#  name               :string(64)       not null
#  private            :boolean          default(FALSE), not null
#  contact_form       :boolean          default(FALSE), not null
#  html_content       :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  main_menu_position :integer
#
# Indexes
#
#  fk__pages_site_id                              (site_id)
#  index_pages_on_site_id_and_main_menu_position  (site_id,main_menu_position) UNIQUE
#  index_pages_on_site_id_and_url                 (site_id,url) UNIQUE
#
# Foreign Keys
#
#  fk_pages_site_id  (site_id => sites.id)
#

class PagesController < ApplicationController
  before_action :new_page, only: [:new, :create]
  before_action :find_page, except: [:index, :new, :create]
  skip_before_action :authenticate_user!, only: [:index, :show, :contact_form]
  before_action :authenticate_page, only: [:show, :contact_form]

  def index
    authorize Page

    @pages = policy_scope(Page).ordered

    respond_to do |format|
      format.html
      format.xml { render xml: xml_sitemap.render }
    end
  end

  def new; end

  def create
    if @page.update_attributes(page_params)
      redirect_to page_path(@page.to_param)
    else
      render :new
    end
  end

  def show; end

  def contact_form
    @message = Message.new

    if @message.update_attributes(message_params)
      NotificationsMailer.new_message(@message).deliver_later
      flash.notice = t('pages.contact_form.flash.success')
      redirect_to page_path(@page.to_param)
    else
      render :show
    end
  end

  def edit; end

  def update
    if @page.update_attributes(page_params)
      redirect_to page_path(@page.to_param)
    else
      render :edit
    end
  end

  def destroy
    @page.destroy!
    redirect_to sitemap_path, alert: t('flash.deleted', name: @page.name)
  end

  private

  def new_page
    @page = @site.pages.new
    authorize @page
  end

  def find_page
    @page = @site.pages.find_by!(url: params[:id])
    authorize @page
  end

  def authenticate_page
    authenticate_user! if @page.private
  end

  def page_params
    params.require(:page).permit(:name, :contact_form, :private, :hidden, :html_content)
  end

  def message_params
    params.require(:message).permit(:name, :email, :phone, :message, :do_not_fill_in).merge(
      site: @site,
      subject: @page.name
    )
  end

  def xml_sitemap
    XmlSitemap::Map.new(@site.host, home: false, secure: true) do |map|
      @pages.each do |page|
        map.add page_path(page.to_param), updated: page.updated_at
      end
    end
  end
end
