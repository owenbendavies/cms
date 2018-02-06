class MessagesAPI < ApplicationAPI
  namespace :messages do
    desc t('.index.description'), success: Message::Entity, is_array: true
    paginate
    get do
      authorize Message, :index?
      present paginate(policy_scope(Message).ordered)
    end

    route_param :uid, type: String do
      before do
        @message = Message.find_by!(uid: params[:uid])
      end

      desc t('.show.description'), success: Message::Entity
      get do
        authorize @message, :show?
        present @message
      end

      desc t('.delete.description')
      delete do
        authorize @message, :destroy?
        @message.destroy!
        present
      end
    end
  end
end
