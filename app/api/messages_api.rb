class MessagesAPI < ApplicationAPI
  namespace :messages do
    desc t('.index.description'), success: Message::Entity, is_array: true
    paginate
    get do
      authorize Message, :index?
      present paginate(policy_scope(Message).ordered)
    end

    desc t('.create.description'), success: Message::Entity
    params do
      requires :all, using: Message::Entity.documentation.slice(:name, :email, :message)
      optional :all, using: Message::Entity.documentation.slice(:phone)
    end
    post do
      message = Message.new(params.merge(site: site))
      authorize message, :create?
      message.save!
      present message
    end

    route_param :uid, type: String do
      desc t('.show.description'), success: Message::Entity
      get do
        message = Message.find_by!(uid: params[:uid])
        authorize message, :show?
        present message
      end

      desc t('.delete.description')
      delete do
        message = Message.find_by!(uid: params[:uid])
        authorize message, :destroy?
        message.destroy!
        present
      end
    end
  end
end
