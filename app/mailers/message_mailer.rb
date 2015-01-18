class MessageMailer < ActionMailer::Base
  def new_message(message)
    @message = message

    mail(
      from: message.site.email,
      to: message.site.users.map(&:email).sort,
      subject: message.subject
    )
  end
end
