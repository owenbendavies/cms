class PagesController < ApplicationController
  before_action :find_page, except: [:new, :create]
  skip_before_action :authenticate_user!, only: [:show, :contact_form]

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(site: @site)

    if @page.update_attributes(page_params.merge(created_by: current_user))
      redirect_to page_path(@page.to_param)
    else
      render :new
    end
  end

  def show
    authenticate_user! if @page.private
  end

  def contact_form
    @message = Message.new

    if @message.update_attributes(message_params)
      @message.deliver
      flash.notice = t('pages.contact_form.flash.success')
      redirect_to page_path(@page.to_param)
    else
      render :show
    end
  end

  def edit
  end

  def update
    if @page.update_attributes(page_params)
      redirect_to page_path(@page.to_param)
    else
      render :edit
    end
  end

  def destroy
    @page.destroy
    redirect_to sitemap_path, alert: t('flash.deleted', name: @page.name)
  end

  private

  def find_page
    @page = Page.find_by_site_id_and_url!(@site, params[:id])
  end

  def page_params
    params.require(:page).permit(
      :name,
      :contact_form,
      :private,
      :html_content
    ).merge(updated_by: current_user)
  end

  def message_params
    params.require(:message).permit(
      :name,
      :email,
      :phone,
      :message,
      :do_not_fill_in
    ).merge(site: @site, subject: @page.name)
  end
end
