class SessionsController < ApplicationController
  skip_before_action :render_site_not_found, only: %i[create]
  skip_before_action :authenticate_user!, only: %i[create invalid]
  skip_after_action :verify_authorized, only: %i[create destroy invalid]

  def create
    user = user_hash

    if valid_user?(user)
      create_site unless @site
      session[:user] = user
      flash.notice = t 'sessions.create.message'
    else
      flash.alert = t 'sessions.invalid.message'
    end

    redirect_to root_path
  end

  def destroy
    reset_session
    flash.notice = t 'sessions.destroy.message'
    redirect_to aws_logout_url
  end

  def invalid
    flash.alert = t 'sessions.invalid.message'
    redirect_to root_path
  end

  private

  def aws_logout_url
    "#{Rails.configuration.x.aws_cognito_domain}/logout?" + {
      client_id: Rails.configuration.x.aws_cognito_client_id,
      logout_uri: root_url
    }.to_param
  end

  def user_hash
    auth = request.env['omniauth.auth']
    info = auth.fetch('info')

    {
      id: auth.fetch('uid'),
      name: info.fetch('name'),
      email: info.fetch('email'),
      groups: auth.fetch('extra').fetch('raw_info').fetch('cognito:groups')
    }
  end

  def valid_user?(user)
    user_groups = user.fetch(:groups)
    user_groups.include?(request.host) || user_groups.include?('admin')
  end

  def create_site
    Site.create!(host: request.host, name: 'New Site', email: Rails.configuration.x.default_site_email)
  end
end
