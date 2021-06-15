class NotificationsMailer < ApplicationMailer
  def new_message(message)
    @message = message

    @site = message.site

    mail(from: from_site(message.site), to: to_users(message.site), subject: t('mailers.new_message.subject'))
  end
end
