class ApplicationController < ActionController::Base
  protect_from_forgery with: :reset_session

  rescue_from ActionView::MissingTemplate, with: :page_not_found
  rescue_from ActionController::UnknownFormat, with: :page_not_found
  rescue_from ActiveRecord::RecordNotFound, with: :page_not_found
  rescue_from CanCan::AccessDenied, with: :page_not_found

  before_action :set_secure_session
  before_action :set_secure_headers
  before_action :find_site
  before_action :render_site_not_found
  before_action :check_format_is_not_html
  before_action :authenticate_user!, except: [:page_not_found]
  before_action :configure_devise_parameters, if: :devise_controller?

  check_authorization unless: :devise_controller?
  skip_authorization_check only: [:page_not_found]

  def page_not_found
    if @site
      render template: 'errors/page_not_found', formats: ['html'], status: 404
    else
      @site = Site.new
      @site.name = t('errors.site_not_found.title')

      render template: 'errors/site_not_found', formats: ['html'], status: 404
    end
  end

  protected

  def configure_devise_parameters
    devise_parameter_sanitizer.for(:account_update).concat [:name]
    devise_parameter_sanitizer.for(:invite).concat [:name]
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
    RequestStore.store[:site] = @site
  end

  def render_site_not_found
    page_not_found unless @site
  end

  def check_format_is_not_html
    page_not_found if params[:format] == 'html'
  end

  def append_info_to_payload(payload)
    super

    payload.merge!(
      host: request.host,
      request_id: request.uuid,
      fwd: request.remote_ip,
      user_id: current_user.try(:id),
      user_agent: request.user_agent
    )
  end
end
