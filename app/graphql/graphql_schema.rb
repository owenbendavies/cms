class GraphqlSchema < GraphQL::Schema
  mutation Types::MutationType
  query Types::QueryType

  def self.id_from_object(object, _type, _context)
    GraphQL::Schema::UniqueWithinType.encode(object.class.name, object.uid)
  end

  def self.object_from_id(id, context)
    class_name, uid = GraphQL::Schema::UniqueWithinType.decode(id)

    Pundit.policy_scope(context, class_name.safe_constantize).find_by(uid: uid)
  end

  def self.resolve_type(_type, object, _context)
    case object
    when Message then Types::MessageType
    when Page then Types::PageType
    when Site then Types::SiteType
    end
  end
end
