module Entities
  class SnsNotification < Grape::Entity
    expose :message
    expose :created_at
    expose :updated_at
  end
end
