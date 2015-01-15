class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from ActionView::MissingTemplate, with: :page_not_found
  rescue_from ActionController::UnknownFormat, with: :page_not_found
  rescue_from ActiveRecord::RecordNotFound, with: :page_not_found

  before_action :set_secure_session
  before_action :set_secure_headers
  before_action :find_site
  before_action :render_site_not_found
  before_action :check_format_is_not_html
  before_action :login_required, except: [:home, :page_not_found]

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

  def check_format_is_not_html
    page_not_found if params[:format] == 'html'
  end

  def login_required
    redirect_to(login_path) unless authenticated?
  end

  def append_info_to_payload(payload)
    super

    payload.merge!(
      host: request.host,
      remote_ip: request.remote_ip,
      request_id: request.uuid,
      user_id: session['warden.user.default.key'],
      user_agent: request.user_agent
    )
  end
end
