class SystemMailer < BaseMailer
  default from: Rails.application.secrets.email_from_address

  def error(message)
    mail(
      to: User.where(sysadmin: true).map(&:email),
      subject: 'ERROR on CMS'
    ) do |format|
      format.text { render text: message }
    end
  end
end
