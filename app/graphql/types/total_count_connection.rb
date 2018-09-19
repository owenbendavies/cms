module Types
  class TotalCountConnection < GraphQL::Types::Relay::BaseConnection
    field :total_count, Int, null: false

    def total_count
      object.nodes.size
    end
  end
end
