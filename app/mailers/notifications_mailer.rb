class NotificationsMailer < ApplicationMailer
  def new_message(message)
    @message = message

    @site = message.site

    mail(
      from: from_site(message.site),
      to: @site.users.pluck(:email),
      subject: message.subject
    )
  end

  def user_added_to_site(user, site, inviter)
    @site = site
    @resource = user
    @inviter = inviter

    mail(
      from: from_site(site),
      to: user.email,
      subject: t('mailers.user_added_to_site.subject')
    )
  end
end
