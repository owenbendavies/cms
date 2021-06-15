class ApplicationController < ActionController::Base
  include Authentication
  include Pundit

  protect_from_forgery with: :reset_session

  rescue_from ActionController::InvalidCrossOriginRequest, with: :page_not_found
  rescue_from ActionController::UnknownFormat, with: :page_not_found
  rescue_from ActiveRecord::RecordNotFound, with: :page_not_found
  rescue_from Pundit::NotAuthorizedError, with: :page_not_found

  before_action :skip_monitoring
  before_action :set_paper_trail_whodunnit
  before_action :find_site
  before_action :render_site_not_found
  before_action :check_format_is_not_html
  before_action :authenticate_user!, except: [:page_not_found]

  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index # rubocop:disable Rails/LexicallyScopedActionFilter

  def page_not_found
    skip_authorization

    respond_to do |format|
      format.html { render page_not_found_template, status: :not_found }
      format.any { head 406 }
    end
  end

  private

  def skip_monitoring
    return unless params[:monitoring] == 'skip'

    ScoutApm::RequestManager.lookup.ignore_request!
  end

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

  def pundit_user
    { user: current_user, site: @site }
  end
end
