class MessageMailer < ActionMailer::Base
  def new_message(message)
    @message = message

    domain = message.site.host.gsub(/^www\./, '')

    from = Mail::Address.new "noreply@#{domain}"
    from.display_name = message.site.name

    mail(
      from: from.format,
      to: message.site.users.map(&:email).sort,
      subject: message.subject
    )
  end
end
