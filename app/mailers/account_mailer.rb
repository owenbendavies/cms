class AccountMailer < Devise::Mailer
  include BaseMailer

  def reset_password_instructions(record, token, opts = {})
    @site = record.sites.first

    super(record, token, opts.merge(from: from_site(@site)))
  end

  alias :unlock_instructions :reset_password_instructions

  def unlock_instructions(record, token, opts = {})
    @site = record.sites.first

    super(record, token, opts.merge(from: from_site(@site)))
  end
end
