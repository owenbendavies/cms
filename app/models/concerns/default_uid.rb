module DefaultUid
  extend ActiveSupport::Concern

  CHARSET = Array('a'..'z') + Array(0..9)

  included do
    before_validation :set_uid
  end

  def set_uid
    self.uid ||= Array.new(8) { CHARSET.sample }.join
  end

  def to_param
    uid
  end
end
