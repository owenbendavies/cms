class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google
    kind = 'Google'

    user = User.find_for_google(uid, email)

    if user
      flash.notice = t 'devise.omniauth_callbacks.success', kind: kind
      sign_in_and_redirect user, event: :authentication
    else
      flash.alert = t 'devise.omniauth_callbacks.failure', kind: kind, reason: 'Invalid credentials'
      redirect_to new_user_session_path
    end
  end

  private

  def uid
    request.env['omniauth.auth']['uid']
  end

  def email
    request.env['omniauth.auth']['info']['email']
  end
end
