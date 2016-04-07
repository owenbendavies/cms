class SystemMailer < BaseMailer
  default from: Rails.application.secrets.email_from_address

  def error(error_message, errors)
    app_name = Rails.application.secrets.app_name

    message = "#{error_message}\n\n#{errors.join("\n")}\n"

    mail(
      to: User.where(sysadmin: true).pluck(:email),
      subject: "ERROR on #{app_name}"
    ) do |format|
      format.text { render text: message }
    end
  end
end
