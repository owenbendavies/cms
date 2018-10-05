class GraphqlSchema < GraphQL::Schema
  query Types::QueryType

  def self.id_from_object(object, _type, _context)
    GraphQL::Schema::UniqueWithinType.encode(object.class.name, object.uid)
  end

  def self.object_from_id(id, context)
    class_name, uid = GraphQL::Schema::UniqueWithinType.decode(id)

    Pundit.policy_scope(context, Object.const_get(class_name)).find_by(uid: uid)
  end

  def self.resolve_type(_type, _object, _context)
    Types::MessageType
  end
end
