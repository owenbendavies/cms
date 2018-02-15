module Entities
  class SystemError < Grape::Entity
    expose :error
    expose :message
    expose :errors, documentation: { type: Hash }
  end
end
