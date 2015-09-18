class CustomDeviseMailer < Devise::Mailer
  protected

  def devise_mail(record, action, opts = {})
    @site = RequestStore.store[:site]

    super(record, action, opts.merge(from: from_site(@site), template_path: 'mailers'))
  end
end
