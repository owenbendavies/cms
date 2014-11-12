class PasswordStrengthValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    password = Zxcvbn.test(value)

    if password.score < 2
      record.errors.add(
        attribute,
        :weak_password,
        time: password.crack_time_display
      )
    end
  end
end
