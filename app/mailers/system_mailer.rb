class SystemMailer < BaseMailer
  default from: ENV['EMAIL_FROM_ADDRESS']

  def error(error_message, errors)
    message = "#{error_message}\n\n#{errors.join("\n")}\n"

    mail(
      to: User.where(sysadmin: true).pluck(:email),
      subject: "ERROR on #{ENV['HEROKU_APP_NAME']}"
    ) do |format|
      format.text { render text: message }
    end
  end
end
