class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from ActionView::MissingTemplate, with: :page_not_found
  rescue_from ActionController::UnknownFormat, with: :page_not_found

  before_filter :find_site
  before_filter :check_format_is_not_html

  def home
    redirect_to page_path('home')
  end

  def page_not_found
    render template: 'errors/page_not_found', formats: ['html'], status: 404
  end

  def login_required
    redirect_to(login_path) unless authenticated?
  end

  private

  def find_site
    @site = Site.find_by_host!(request.host)
  end

  def check_format_is_not_html
    page_not_found if params[:format] == 'html'
  end

  def append_info_to_payload(payload)
    super

    payload.merge!({
      host: request.host,
      remote_ip: request.remote_ip,
      request_id: request.env['HTTP_HEROKU_REQUEST_ID'],
      account_id: session['warden.user.default.key'],
      user_agent: request.user_agent,
    })
  end
end
