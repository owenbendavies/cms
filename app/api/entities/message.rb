module Entities
  class Message < Grape::Entity
    expose :uid
    expose :name
    expose :email
    expose :phone
    expose :message
    expose :created_at
    expose :updated_at
  end
end
