module DefaultUid
  extend ActiveSupport::Concern

  CHARSET = Array('a'..'z') + Array(0..9)

  included do
    # default values
    default_value_for :uid do
      Array.new(8) { CHARSET.sample }.join
    end

    # validations
    validates(
      :uid,
      presence: true,
      uniqueness: true
    )
  end

  def to_param
    uid
  end
end
