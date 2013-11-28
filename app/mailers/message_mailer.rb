class MessageMailer < ActionMailer::Base
  def new_message(message)
    @message = message

    domain = message.site.host.gsub(/^www\./, '')

    from = Mail::Address.new "noreply@#{domain}"
    from.display_name = message.site.name

    mail(
      from: from.format,
      to: Account.find_emails_by_site(message.site),
      subject: message.subject,
    )
  end
end
