class InvitationsController < Devise::InvitationsController
  before_action :authorize_user, except: %i[edit update]

  def authorize_user
    authorize User
  end

  def invite_resource
    User.invite_or_add_to_site!(invite_params, @site, current_user)
  end

  def after_invite_path_for(_resource)
    site_users_path
  end
end
