class ApplicationMailer < ActionMailer::Base
  default template_path: 'mailers'
  helper :application
  layout 'mailer'

  protected

  def from_site(site)
    default_url_options.merge! site.url_options

    from = Mail::Address.new(site.email)
    from.display_name = site.name
    from
  end
end
