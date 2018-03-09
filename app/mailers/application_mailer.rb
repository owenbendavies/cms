class ApplicationMailer < ActionMailer::Base
  default template_path: 'mailers'
  helper :application
  layout 'mailer'

  protected

  def from_site(site)
    default_url_options[:host] = site.host
    default_url_options[:protocol] = ENV['DISABLE_SSL'] ? 'http' : 'https'
    default_url_options[:port] = ENV['EMAIL_LINK_PORT']

    from = Mail::Address.new(site.email)
    from.display_name = site.name
    from
  end
end
