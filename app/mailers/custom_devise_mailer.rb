class CustomDeviseMailer < Devise::Mailer
  protected

  def devise_mail(record, action, opts = {})
    @site = record.sites.first

    super(record, action, opts.merge(from: from_site(@site), template_path: 'mailers'))
  end
end
