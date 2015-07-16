class MessageMailer < ActionMailer::Base
  include BaseMailer

  def new_message(message)
    @message = message

    @site = message.site

    mail(
      from: from_site(message.site),
      to: @site.all_users.map(&:email).sort,
      subject: message.subject
    )
  end
end
