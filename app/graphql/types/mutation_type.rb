module Types
  class MutationType < BaseObject
    field :create_page, mutation: Mutations::CreatePage
    field :delete_messages, mutation: Mutations::DeleteMessages
    field :delete_pages, mutation: Mutations::DeletePages
    field :update_page, mutation: Mutations::UpdatePage
    field :update_site, mutation: Mutations::UpdateSite
  end
end
