class SystemMailer < BaseMailer
  default from: Rails.application.secrets.email_from_address

  def error(message)
    app_name = Rails.application.secrets.app_name

    mail(
      to: User.where(sysadmin: true).map(&:email),
      subject: "ERROR on #{app_name}"
    ) do |format|
      format.text { render text: message }
    end
  end
end
