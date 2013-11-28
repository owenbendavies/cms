class ApplicationController < ActionController::Base
  class InvalidSessionHost < RuntimeError; end

  protect_from_forgery with: :exception

  before_filter :find_site
  before_filter :find_account
  before_filter :check_session
  before_filter :check_format_is_nil

  def home
    redirect_to page_path('home')
  end

  def page_not_found
    params[:format] = nil
    render template: 'errors/page_not_found', status: 404
  end

  def login_required
    redirect_to(login_path) unless @account
  end

  private

  def find_site
    @site = Site.find_by_host!(request.host)
  end

  def find_account
    @account = Account.find_by_id(session[:account_id]) if session[:account_id]
  end

  def check_session
    raise InvalidSessionHost if @account and session[:host] != @site.host
  end

  def check_format_is_nil
    page_not_found unless params[:format].nil?
  end

  def append_info_to_payload(payload)
    super
    payload[:host] = request.host
    payload[:remote_ip] = request.remote_ip
  end
end
