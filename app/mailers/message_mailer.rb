class MessageMailer < ActionMailer::Base
  def new_message(message)
    @message = message

    site = message.site
    from = Mail::Address.new(site.email)
    from.display_name = site.name

    mail(
      from: from,
      to: site.users.map(&:email).sort,
      subject: message.subject
    )
  end
end
