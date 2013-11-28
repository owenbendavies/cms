class SessionController < ApplicationController
  def login
    if request.post?
      email = params['account']['email']
      password = params['account']['password']

      if account = Account.find_and_authenticate(email, password, @site)
        session[:account_id] = account.id
        session[:host] = @site.host
        home
      else
        flash[:error] = t('session.login.flash.invalid_login')
      end
    end
  end

  def logout
    reset_session
    home
  end
end
