class PagesController < ApplicationController
  load_resource find_by: :url, through: :site

  skip_before_action :authenticate_user!, only: [:show, :contact_form]
  before_action :authenticate_page, only: [:show, :contact_form]

  authorize_resource

  def new
  end

  def create
    if @page.update_attributes(page_params)
      redirect_to page_path(@page.to_param)
    else
      render :new
    end
  end

  def show
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

  def authenticate_page
    authenticate_user! if @page.private
  end

  def page_params
    params.require(:page).permit(
      :name,
      :contact_form,
      :private,
      :html_content
    )
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
