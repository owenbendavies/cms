class AccountMailer < Devise::Mailer
  include BaseMailer

  def confirmation_instructions(record, token, opts = {})
    @site = record.sites.first

    super(record, token, opts.merge(from: from_site(@site)))
  end

  def reset_password_instructions(record, token, opts = {})
    @site = record.sites.first

    super(record, token, opts.merge(from: from_site(@site)))
  end

  def unlock_instructions(record, token, opts = {})
    @site = record.sites.first

    super(record, token, opts.merge(from: from_site(@site)))
  end
end
