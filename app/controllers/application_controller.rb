class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :reset_session

  rescue_from ActionView::MissingTemplate, with: :page_not_found
  rescue_from ActionController::UnknownFormat, with: :page_not_found
  rescue_from ActiveRecord::RecordNotFound, with: :page_not_found
  rescue_from Pundit::NotAuthorizedError, with: :page_not_found

  before_action :set_paper_trail_whodunnit
  before_action :find_site
  before_action :render_site_not_found
  before_action :check_format_is_not_html
  before_action :authenticate_user!, except: [:page_not_found]
  before_action :configure_devise_parameters, if: :devise_controller?

  after_action :verify_authorized, unless: :devise_controller?
  after_action :verify_policy_scoped, only: :index, unless: :devise_controller?

  def page_not_found
    skip_authorization

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
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    devise_parameter_sanitizer.permit(:invite, keys: [:name])
  end

  private

  def find_site
    @site = Site.find_by(host: request.host)
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

  def pundit_user
    { user: current_user, site: @site }
  end
end
