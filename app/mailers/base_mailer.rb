module BaseMailer
  extend ActiveSupport::Concern

  included do
    helper :application

    layout 'mailer'

    private

    def from_site(site)
      default_url_options[:host] = site.host

      from = Mail::Address.new(site.email)
      from.display_name = site.name
      from
    end
  end
end
