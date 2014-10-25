class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from ActionView::MissingTemplate, with: :page_not_found
  rescue_from ActionController::UnknownFormat, with: :page_not_found

  before_filter :find_site
  before_filter :render_site_not_found
  before_filter :check_format_is_not_html
  before_filter :login_required, except: [:home, :page_not_found]

  helper_method :feature

  def home
    redirect_to page_path('home')
  end

  def page_not_found
    if @site
      render template: 'errors/page_not_found', formats: ['html'], status: 404
    else
      @site = Site.new
      @site.name = t('errors.site_not_found.title')
      @site.layout = 'site_not_found'

      render template: 'errors/site_not_found', formats: ['html'], status: 404
    end
  end

  protected

  def login_required
    redirect_to(login_path) unless authenticated?
  end

  def feature
    @features ||= Features.find_by_id('features')
  end

  private

  def find_site
    @site = Site.find_by_host(request.host)
  end

  def render_site_not_found
    page_not_found unless @site
  end

  def check_format_is_not_html
    page_not_found if params[:format] == 'html'
  end

  def append_info_to_payload(payload)
    super

    payload.merge!({
      host: request.host,
      remote_ip: request.remote_ip,
      request_id: request.uuid,
      account_id: session['warden.user.default.key'],
      user_agent: request.user_agent,
    })
  end
end
