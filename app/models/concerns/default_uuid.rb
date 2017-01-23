module DefaultUuid
  extend ActiveSupport::Concern

  included do
    before_validation :set_uuid
  end

  def set_uuid
    self.uuid ||= SecureRandom.uuid
  end

  def to_param
    uuid
  end
end
