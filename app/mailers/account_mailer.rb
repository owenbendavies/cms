class AccountMailer < Devise::Mailer
  def unlock_instructions(record, token, opts = {})
    site = record.sites.first

    @host = site.host

    super(record, token, opts.merge(from: site.email))
  end
end
