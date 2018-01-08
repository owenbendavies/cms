module Helpers
  module Authentication
    def warden
      env['warden']
    end

    def current_user
      warden.user
    end

    def site
      @site ||= Site.find_by(host: request.host)
    end

    def pundit_user
      { user: current_user, site: site }
    end
  end
end
