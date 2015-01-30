class AccountMailer < Devise::Mailer
  def reset_password_instructions(record, token, opts = {})
    site = record.sites.first

    default_url_options[:host] = site.host

    super(record, token, opts.merge(from: site.email))
  end

  def unlock_instructions(record, token, opts = {})
    site = record.sites.first

    default_url_options[:host] = site.host

    super(record, token, opts.merge(from: site.email))
  end
end
