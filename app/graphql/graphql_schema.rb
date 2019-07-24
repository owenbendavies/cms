class GraphqlSchema < GraphQL::Schema
  mutation Types::MutationType
  query Types::QueryType

  def self.id_from_object(object, _type, _context)
    GraphQL::Schema::UniqueWithinType.encode(object.class.name, object.id)
  end

  def self.object_from_id(id, context)
    class_name, item_id = GraphQL::Schema::UniqueWithinType.decode(id)

    Pundit.policy_scope(context, class_name.safe_constantize).find(item_id)
  end

  def self.resolve_type(_type, object, _context)
    case object
    when Image then Types::ImageType
    when Message then Types::MessageType
    when Page then Types::PageType
    when Site then Types::SiteType
    end
  end
end
