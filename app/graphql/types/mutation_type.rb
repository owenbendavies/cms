module Types
  class MutationType < BaseObject
    field :delete_messages, mutation: Mutations::DeleteMessages
    field :delete_pages, mutation: Mutations::DeletePages
    field :update_site, mutation: Mutations::UpdateSite
  end
end
