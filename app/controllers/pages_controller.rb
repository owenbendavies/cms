class PagesController < ApplicationController
  before_filter :find_page, except: [:new, :create]
  skip_before_filter :login_required, only: [:show, :contact_form]

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(site_id: @site.id)

    if @page.update_attributes(page_params.merge(created_by: user.id))
      redirect_to page_path(@page.url)
    else
      render :new
    end
  end

  def show
    login_required if @page.private
  end

  def contact_form
    @message = Message.new

    if @message.update_attributes(message_params)
      @message.deliver
      flash[:success] = t('pages.contact_form.flash.success')
      redirect_to page_path(@page.url)
    else
      @message.save_spam_message
      render :show
    end
  end

  def edit
  end

  def update
    if @page.update_attributes(page_params)
      redirect_to page_path(@page.url)
    else
      render :edit
    end
  end

  def destroy
    @page.destroy
    flash[:error] = t('flash.deleted', name: @page.name)
    redirect_to sitemap_path
  end

  private

  def find_page
    @page = Page.find_by_site_and_url(@site, params[:id])
    return page_not_found unless @page
  end

  def page_params
    params.require(:page).permit(
      :name,
      :private,
      :html_content
    ).merge(updated_by: user.id)
  end

  def message_params
    params.require(:message).permit(
      :name,
      :email_address,
      :phone_number,
      :message,
      :do_not_fill_in
    ).merge({
      site: @site,
      subject: @page.name
    })
  end
end
