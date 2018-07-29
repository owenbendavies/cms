module Helpers
  module Authentication
    def session
      env['rack.session']
    end

    def current_user
      @current_user ||= User.new(session[:user]) if session[:user]
    end

    def site
      @site ||= Site.find_by(host: request.host)
    end

    def pundit_user
      { user: current_user, site: site }
    end
  end
end
