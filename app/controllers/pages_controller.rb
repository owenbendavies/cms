class PagesController < ApplicationController
  before_action :find_page, except: %i[index]
  skip_before_action :authenticate_user!
  before_action :authenticate_page, only: %i[show contact_form]

  invisible_captcha(
    only: [:contact_form],
    scope: :message,
    honeypot: :surname,
    on_spam: :contact_form_error
  )

  def index
    authorize Page

    @pages = policy_scope(Page).ordered

    respond_to do |format|
      format.html
      format.xml { render xml: xml_sitemap.render }
    end
  end

  def new; end

  def show; end

  def contact_form
    @message = Message.new

    if @message.update(message_params)
      NotificationsMailer.new_message(@message).deliver_later
      flash.notice = t('pages.contact_form.flash.success')
      redirect_to page_path(@page)
    else
      contact_form_error
    end
  end

  def contact_form_error
    flash.alert = t('pages.contact_form.flash.alert')
    render :show
  end

  private

  def find_page
    @page = @site.pages.find_by!(url: params[:id])
    authorize @page
  end

  def authenticate_page
    authenticate_user! if @page.private
  end

  def message_params
    params.require(:message).permit(
      :name, :email, :phone, :message, :privacy_policy_agreed
    ).merge(
      site: @site
    )
  end

  def xml_sitemap
    XmlSitemap::Map.new(@site.host, home: false, secure: ENV['DISABLE_SSL'].blank?) do |map|
      @pages.each do |page|
        map.add page_path(page), updated: page.updated_at
      end
    end
  end
end
