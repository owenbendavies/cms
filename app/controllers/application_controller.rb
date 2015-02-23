class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from ActionView::MissingTemplate, with: :page_not_found
  rescue_from ActionController::UnknownFormat, with: :page_not_found
  rescue_from ActiveRecord::RecordNotFound, with: :page_not_found

  before_action :set_secure_session
  before_action :set_secure_headers
  before_action :find_site
  before_action :render_site_not_found
  before_action :check_user_site
  before_action :check_format_is_not_html
  before_action :authenticate_user!, except: [:home, :page_not_found]

  def home
    redirect_to page_path('home')
  end

  def page_not_found
    if @site
      render template: 'errors/page_not_found', formats: ['html'], status: 404
    else
      @site = Site.new
      @site.name = t('errors.site_not_found.title')

      render template: 'errors/site_not_found', formats: ['html'], status: 404
    end
  end

  private

  def set_secure_session
    session.options[:secure] = true if request.ssl?
  end

  def csp_options
    origins = request.ssl? ? 'https:' : '*'

    {
      default_src: origins,
      disable_fill_missing: true,
      enforce: true,
      script_src: "#{origins} inline",
      style_src: "#{origins} inline"
    }
  end

  def set_secure_headers
    set_security_headers(
      hsts: { max_age: 1.month.to_i },
      x_xss_protection: { value: 1, mode: 'block' },
      csp: csp_options
    )
  end

  def find_site
    @site = Site.find_by_host(request.host)
  end

  def render_site_not_found
    page_not_found unless @site
  end

  def check_user_site
    return unless current_user
    return if current_user.sites.map(&:host).include?(@site.host)
    sign_out
  end

  def check_format_is_not_html
    page_not_found if params[:format] == 'html'
  end

  def append_info_to_payload(payload)
    super

    output = payload.merge!(
      host: request.host,
      remote_ip: request.remote_ip,
      request_id: request.uuid,
      user_agent: request.user_agent
    )

    output[:user_id] = current_user.id if current_user
    output
  end
end
