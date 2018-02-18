module Entities
  class SystemHealth < Grape::Entity
    expose :all, documentation: { type: 'Boolean' }

    def all
      true
    end
  end
end
