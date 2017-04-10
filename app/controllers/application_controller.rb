class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :reset_session

  rescue_from ActionController::InvalidCrossOriginRequest, with: :page_not_found
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

    respond_to do |format|
      format.html { render page_not_found_template, status: 404 }
      format.any { head 406 }
    end
  end

  protected

  def configure_devise_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    devise_parameter_sanitizer.permit(:invite, keys: [:name])
  end

  private

  def page_not_found_template
    if @site
      'errors/page_not_found'
    else
      @site = Site.new
      @site.name = t('errors.site_not_found.title')

      'errors/site_not_found'
    end
  end

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
