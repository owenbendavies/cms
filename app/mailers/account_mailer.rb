class AccountMailer < Devise::Mailer
  helper :application

  layout 'mailer'

  def reset_password_instructions(record, token, opts = {})
    @site = record.sites.first

    default_url_options[:host] = @site.host

    from = Mail::Address.new(@site.email)
    from.display_name = @site.name

    super(record, token, opts.merge(from: from))
  end

  def unlock_instructions(record, token, opts = {})
    @site = record.sites.first

    default_url_options[:host] = @site.host

    from = Mail::Address.new(@site.email)
    from.display_name = @site.name

    super(record, token, opts.merge(from: from))
  end
end
